*Combine log and extract the product code viewed by session;
/*libname Lweblog '\\censafp1\ESS\weblog\dataset\';*/

options compress=yes;

%let yearmonth=201406;		*edit the yearmonth before run;
/*libname Lweblog "\\censafp1\ess\weblog\dataset&yearmonth.";*/
/*libname Lweblog "\\cenqess115634\Statistics\_Dennis\dataset&yearmonth.";*/
/*libname Lweblog "\\cenqess115634\Statistics\_Dennis\dataset&yearmonth.";*/
libname Lweblog "\\censeadfsp09\SASTemp\dataset&yearmonth.";

/*%let path=\\censafp1\ESS\weblog\;*/

%let path1=\\censeadfsp09\SASTemp\log&yearmonth.;
/*%let path1=\\cenqess115634\Statistics\Access log\&yearmonth._log\log&yearmonth.;*/

%let path2=\\censeadfsp09\SASTemp;
/*%let path2=\\censafp1\ESS\weblog;*/

%let path3=\\censeadfsp09\SASTemp\dataset&yearmonth.;

%macro combine_dataset(mth /*mth e.g 201403*/) ;
*x respresent the last day of mth;
%if %substr(&mth.,5,2)=12 %then %let x = 31;   
%else %let x =  %sysfunc(day(%eval(%sysfunc(MDY(%substr(&mth.,5,2)+1,1,%substr(&mth.,1,4))))-1));
%put &mth.;
*y represent the dataset to be merged;
%let y= ;
	%do i= 1 %to &x. %by 1;
		%let serial = %substr(%eval(100+&i.),2,2);   *convert 1 to 01 for filename;
		%let y= &y.  Lweblog.d&mth.&serial.;
	%end;
	%put &y.;
	data alldata(compress=yes) ;  
	set &y.;
	run;
%mend;

*merge all log of specified month to once;
%combine_dataset(&yearmonth.);

*read spider host;  *.......we can further exlude the spider host provided by weblog expert if the spider cannot be identify by useragent;
data Lweblog.spiderhost  (compress=yes) ;   
	infile "&path1.\spiderhost.txt";
	input ip :$50. ; 
run;
*read product list;
data productlist(compress=yes) ;   
	infile "&path2.\Program_Product_basket_analysis\productlist.txt"
	  line=Linept col=Columnpt lrecl=2000 	truncover  	delimiter="," dsd  
	firstobs=2  /* obs=10000   */;
	input url :$50.   productcd :$30. ; 
run;

* join the monthly data and exclude spider host found from weblog expert;
proc sql;
create table all_excludedspider as 
	select
			 a.month_sessionid,a.readorder, a.query, a.classification
	from
	alldata a
    left join
	Lweblog.spiderhost b on a.ip = b.ip 
	where b.ip is null 
			and a.ip ^='192.234.235.103'	/*exclude special spider that not in spider host*/
			and a.ip ^='64.209.89.103'		/*exclude special spider that not in spider host*/
			and substr(a.ip,1,8) ^='202.128.' 			/*exclude GovIP*/
			and substr(a.ip,1,7) ^='69.191.' 			/*exclude robot for press release and home*/
	order by month_sessionid, readorder, query, classification ;
run;
*extract the required classification;
proc sql;
create table products as 
select month_sessionid, min(readorder) as seq, query, classification 
from all_excludedspider
where (classification = 'HTML' or 
		 classification = 'productpage' or 
		 classification = 'Chart')
		 and query ^=''
group by query, classification, month_sessionid
order by month_sessionid, seq, query, classification
;
quit;
*data cleaning and rearrange the parameter in url;
data  products_cleaned(compress=yes) ;  
	set products ;
	query1 = tranwrd(query,'&amp;',"&");
	query1 = tranwrd(query1,"/","");
	query1 = tranwrd(query1,'&r=em',"");
	query1 = tranwrd(query1,"%20","");
	query1 = tranwrd(query1,"+","");
	a1=scan(query1,1,"&"); 
	call symput('a1',a1);
	a2=scan(query1,2,"&"); 
	call symput('a2',a2);
	a3=scan(query1,3,"&"); 
	call symput('a3',a3);  
	a4=scan(query1,4,"&");
	call symput('a4',a4);
	do i = 1 to 4;
	   if find(symget('a' || put(i,$1.) ),"ID=")>0 and find(symget('a' || put(i,$1.) ),"tableID=")=0 and find(symget('a' || put(i,$1.) ),"subjectID=")=0then ID=symget('a' || put(i,$1.));
	   if find(symget('a' || put(i,$1.) ),"tableID=")>0 then table=symget('a' || put(i,$1.));
	   if find(symget('a' || put(i,$1.) ),"productCode=")>0 then productCode=symget('a' || put(i,$1.));
	   if find(symget('a' || put(i,$1.) ),"productType=")>0 then productType=symget('a' || put(i,$1.));
	end;
url = '                                                                    ';
if classification = 'HTML' or classification = 'Chart' then url = trim(table) || "&" || trim(ID) || "&" || trim(productType);
else if classification = 'productpage' then url = productCode;
drop a1 a2 a3 a4 i table ID productCode productType query query1
;
run;
*join the product code and retain the record with valid product code and unique the dataset again;
proc sql;
create table product_url as 
select month_sessionid, min(seq) as minseq, classification, productcd
from products_cleaned a left join productlist b on a.url = b.url
where b.productcd is not null
group by month_sessionid, classification, productcd
order by month_sessionid, classification, productcd
;
quit;
*join the product code to see whether there is any product is missing in product list;
proc sql;
create table product_url_unknown as 
select a.classification, a.url,count(1) as c
from products_cleaned a left join productlist b on a.url = b.url
where b.productcd is null
group by  a.classification, a.url
order by c desc
;
quit;
*assign sequence number;
proc sort data=product_url;
by month_sessionid minseq;
run;
data Lweblog.product_url_2;
set product_url;
by month_sessionid;
if first.month_sessionid then sequence=1;
else sequence=sequence+1;
retain sequence;
drop minseq;
run;

*distribution of no_of_product and no_of_session;
proc sql;
create table distribution as 
select no_of_product, count(1) as no_of_session
	from (select  month_sessionid, count(1) as no_of_product
	from Lweblog.product_url_2
	group by month_sessionid)
	group by no_of_product
;
quit;

*delete tmp dataset;
/*
proc datasets library=work;
   delete 
			 alldata
   			 all_excludedspider
			 products
			 products_cleaned	
			 product_url
run;
*/

*Output;
/*
proc export data=Lweblog.product_url_2
   outfile="&path3.\viewed_product1.csv"
   replace;
run;