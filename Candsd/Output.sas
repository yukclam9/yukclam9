Options COMPRESS=YES; 

proc sql;
create table all_excludedspider as 
	select
			 a._session_id , a.session_id, a.query, a.classification,a.time
	from
	 &datafile. as a
    left join
	&month..spider as b on a.ip = b.ip 
	where b.ip is null 
			and a.ip ^='192.234.235.103'	/*exclude special spider that not in spider host*/
			and a.ip ^='64.209.89.103'		/*exclude special spider that not in spider host*/
			and substr(a.ip,1,8) ^='202.128.' 			/*exclude GovIP*/
			and substr(a.ip,1,7) ^='69.191.' 			/*exclude robot for press release and home*/
	order by _session_id, time, query, classification ;
quit;
*extract the required classification;
proc sql;
create table products as 
select _session_id,session_id,time, query, classification 
from all_excludedspider
where (classification = 'HTML' or 
		 classification = 'productpage' or 
		 classification = 'Chart')
		 and query ^=''
order by _session_id, time 
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
select _session_id, session_id,time, query, classification, productcd
from products_cleaned a left join files.productlist b on a.url = b.url
where b.productcd is not null
order by _session_id, time, classification, productcd
;
quit;
*join the product code to see whether there is any product is missing in product list;
proc sql;
create table product_url_unknown as 
select a.classification, a.url,count(1) as c
from products_cleaned a left join files.productlist b on a.url = b.url
where b.productcd is null
group by  a.classification, a.url
order by 3 desc
;
quit;
*assign sequence number;
proc sort data=product_url noduprecs;
by _session_id  time  productcd;
run;

data &month..product_url_2  (compress=yes);
set product_url;
by _session_id;
if first._session_id then view +1;
run;

*distribution of no_of_product and no_of_session;
proc sql;
create table &month..distribution as 
select no_of_product, count(1) as no_of_session
	from (select _session_id, count(1) as no_of_product
	from product_url
	group by _session_id )
	group by no_of_product
	;
quit;

	

proc transpose data=&month..product_url_2 out=product(drop= _session_id session_id view productcd _name_) ;
by view;
var productcd;
run;

data &month..product (compress=yes);
	set product  ;
	where col&start. not eq "" and col&end.="" ;
	run;

proc export data=&month..product
   outfile="\\censeadfsp09\SASTemp\dataset2014&serial.\&month._product.csv"
   dbms =  csv
   replace;
   *remove the column name at the first row of the csv file;
   putnames = no ;
run;

proc datasets library=work;
   delete 
			 alldata
   			 all_excludedspider
			 products
			 products_cleaned	
			 product_url
			 product
run;