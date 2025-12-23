/*Data Exploration*/
PROC IMPORT DATAFILE="/home/u64118479/sasuser.v94/aivshuman.csv" OUT=writing DBMS=CSV REPLACE;
	GETNAMES=YES;
RUN;

/*Creating a new data set that makes label into a 0/1 binary variable*/
DATA tellwriting;
	SET writing;
	IF label = 'human' THEN human = 1;
	IF label = 'ai' THEN human = 0;
RUN;

/*Panel scatter of binary variable against each predictor with loess smooth*/
PROC SGSCATTER DATA=tellwriting;
	COMPARE Y=(human) X=(length_chars length_words quality_score sentiment plagiarism_score)/LOESS;
RUN;
/*For single variate analysis, I choose plagiarism_score because to me it looks the most logistic-shaped*/

/*-------------------------------------------------------------------*/
/*Single Variate Analysis*/

/*logistic regression model (will have significance and tests)*/
PROC LOGISTIC DATA=tellwriting;
	MODEL human(EVENT='1') = plagiarism_score;
RUN;

/*rank data into 10 groups for empirical logit*/
PROC RANK DATA=tellwriting GROUPS=10 OUT=bins;
    VAR plagiarism_score;
    RANKS plag_bin;
RUN;

/*find bin data and export*/
PROC MEANS DATA=bins NOPRINT;
    CLASS plag_bin;
    VAR human plagiarism_score;
    OUTPUT OUT=logit SUM(human)=y N(human)=n MEAN(plagiarism_score)=xbar;
RUN;

/*calculate empirical logit*/
DATA emplogit;
    SET logit;
    IF n>0 THEN elogit = LOG((y + 0.5)/(n-y+0.5));
RUN;

/*plot empirical logit*/
PROC SGPLOT DATA=emplogit;
    SCATTER X=xbar Y=elogit;
    REG X=xbar Y=elogit;  
RUN;
/*linearity met*/

/*-------------------------------------------------------------------*/
/*Multivariate analysis*/

/*Find variance inflation factor (VIF), if its bigger than 5, it has multicollinearity with something*/
PROC REG DATA=tellwriting;
	MODEL human = length_chars length_words quality_score sentiment plagiarism_score/VIF;
RUN;
/*Word length and char length are obviously highly correlated, i remove char length because both end up being significant anyways*/
PROC REG DATA=tellwriting;
	MODEL human = length_words quality_score sentiment plagiarism_score/VIF;
RUN;
/*VIF Problem disappears*/

/*Find a best model using stepwise selection method*/
PROC LOGISTIC DATA=tellwriting;
	MODEL human(EVENT='1') = length_words quality_score sentiment plagiarism_score/
	SELECTION=stepwise;
RUN;
/*Assess given model*/

/*Hypothetical "new data point" to test - only considers predictors selected for model*/
DATA newpoint;
   length_words = 30;
   quality_score = 5;
   plagiarism_score = 0.2;
RUN;

/*set datapoint into a new dataset at the top*/
DATA tellwriting_new;
	SEt newpoint tellwriting;
RUN;

/*calculate predicted probability for that datapoint*/
PROC LOGISTIC DATA=tellwriting_new;
    MODEL human(EVENT='1') = length_words quality_score plagiarism_score;
    OUTPUT OUT=prediction p=phat;
RUN;

/*print (phat is what is needed)*/
PROC PRINT DATA=prediction (OBS=1);

/*roc curve for best model*/
PROC LOGISTIC DATA=tellwriting PLOTS(ONLY)=roc; /*best*/
	MODEL human(EVENT='1') = length_words quality_score plagiarism_score;
RUN;
/*roc curve for a different model with worse predictors*/
PROC LOGISTIC DATA=tellwriting PLOTS(ONLY)=roc; /*random*/
	MODEL human(EVENT='1') = length_chars quality_score sentiment;
RUN;
/*their areas are starkly different*/