/*%let path=\\censafp1\ESS\weblog;*/
%let path=\\censeadfsp09\SASTemp;

options compress=yes;

%let yyyymm=201403;		*edit the yearmonth before run;
/*libname Lweblog "\\censafp1\ess\weblog\dataset&yyyymm.";*/
libname Lweblog "\\censeadfsp09\SASTemp\dataset&yyyymm.";

proc sql;
create table Lweblog.pageview as
select distinct month_sessionid, classification, productcd
from Lweblog.product_url_2
;
quit;

proc sql;
create table Lweblog.pageview as
select productcd, classification, count(*) as pageview
from Lweblog.pageview
group by productcd, classification
;
quit;

proc sql;
select sum(pageview)
from Lweblog.pageview
;
quit;

data mapping01;
infile "&path.\Program_Product_basket_analysis\mapping01.csv"
	  line=Linept col=Columnpt lrecl=2000 	truncover  	delimiter="," dsd  
	firstobs=2  /* obs=10000   */;
	length 	productcd $30
			engTitle engURL chiTitle chiURL $500;
	input productcd engTitle engURL chiTitle chiURL; 

/*proc sql;*/
/*create table Lweblog.pageview as*/
/*select **/
/*from Lweblog.pageview a*/
/*left join mapping01 b*/
/*on a. productcd = b.productcd*/
/*;*/

proc export data=Lweblog.pageview
   outfile="&path.\dataset&yyyymm.\pageview.csv"
   replace;
run;


