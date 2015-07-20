
/*%let path=\\censafp1\ESS\weblog\;*/
%let path=\\censeadfsp09\SASTemp\;
options compress=yes;

/*%let yearmonth=201403;		*edit the yearmonth before run;*/

* read the log of specified month at once, input the month, the program will read the log of the month;
%macro read_1_month(mth /*mth e.g 201403*/) ;
libname Lweblog "\\censeadfsp09\SASTemp\dataset&mth.";
/*libname Lweblog "\\cenqess115634\Statistics\_Dennis\dataset&mth.";*/
/*libname Lweblog "\\censafp1\ess\weblog\dataset&mth.";*/
/*libname Lweblog "\\dept\wsc2013\WSC2013\Dennis\dataset&mth.";*/

*if the month is dec, the last day is 31;
	*otherwise get the last day of specifiec month;
%if %substr(&mth.,5,2)=12 %then %let x = 31;   
%else %let x =  %sysfunc(day(%eval(%sysfunc(MDY(%substr(&mth.,5,2)+1,1,%substr(&mth.,1,4))))-1));
%put &mth.;
%put &x.;
*call another marco to read the log of specified date;
/*	%do i= 1 %to &x. %by 1;*/
	%do i= 1 %to 1 %by 1;
		%let serial = %substr(%eval(100+&i.),2,2);   *convert 1 to 01 for filename;
		%put &mth.&serial.;
		%read_1_day(&mth., &mth.&serial.);
	%end;
%mend;

*******************************************************************;
%macro read_1_day (yyyymm, date /*date e.g 20140401*/ ) ;
	%let month_data_prex=Lweblog.D;

	*read and extract required pages for provided date;
	%if %eval(&yyyymm.)<201407 %then %do;
		filename read ("\\censeadfsp09\SASTemp\log&yyyymm.\*&date*.dat");
/*		filename read ("\\cenqess115634\Statistics\Access log\&yyyymm._log\log&yyyymm.\*&date*.dat");*/
/*		filename read ("\\censafp1\ess\weblog\log&yyyymm.\*&date*.dat");*/
/*		filename read ("\\dept\wsc2013\WSC2013\Dennis\log&yyyymm.\*&date*.dat");*/
	%end;
	%else %do;
		filename read ("\\censeadfsp09\SASTemp\log&yyyymm.\*&date*.log");
/*		filename read ("\\censafp1\ess\weblog\log&yyyymm.\*&date*.log");*/
/*		filename read ("\\dept\wsc2013\WSC2013\Dennis\log&yyyymm.\*&date*.log");*/
	%end;
	%let infilename=read;
	%include "&path\Program_Product_basket_analysis\readweblog_ex.sas";		
	***************************************************************************;
	*re-generate session id;
	Data &day_data;
	set &temp_data; 
*	where ip='64.209.89.103';
	run;
	%include "&path\Program_Product_basket_analysis\derive_session.sas";
	***************************************************************************;
	*classification of page;
	%include "&path\Program_Product_basket_analysis\classify.sas";
	*******************************************************************;
	*export the day data, set the sessionid with prefix of the provided date;
	data &month_data_prex&date;
	set &day_data;  
		*month_sessionid = put(date,YYMMDD10.) || put(new_newsessionid,10.);
		month_sessionid = put(&date,8.) || put(new_newsessionid,10.);
	run;
%mend;


*name of dataset;
%let temp_data=Dweblog_tmp1;
%let day_data=Dweblog;


*read log day by day of the month;
/*%read_1_month(&yearmonth.);*/
/*%read_1_month(201401);*/
/*%read_1_month(201402);*/
/*%read_1_month(201403);*/
/*%read_1_month(201404);*/
/*%read_1_month(201405);*/
/*%read_1_month(201406);*/
%read_1_month(201406);

*******************************************************************;
