libname July  "  \\censeadfsp09\SASTemp\dataset201407\ " ;
libname August "  \\censeadfsp09\SASTemp\dataset201408\ " ;
libname Sept "  \\censeadfsp09\SASTemp\dataset201409\ " ;
libname Oct "  \\censeadfsp09\SASTemp\dataset201410\ " ;
libname Nov  "  \\censeadfsp09\SASTemp\dataset201411\ " ;
libname Dec  "  \\censeadfsp09\SASTemp\dataset201412\ " ;
libname files  "\\censeadfsp09\SASTemp\Program_Product_basket_analysis\ ";

Options COMPRESS=YES; 

%macro input_log (year,  month, n);
%global day, mon ;

%if (&month = Jan) or (&month = March) or (&month = May) or (&month = July) or ( &month= August) or (&month = Oct) or (&month = Dec) %then %let day = 31;
%else %if (&month = April) or  (&month = June) or  (&month = Sept) or  (&month = Nov)  %then %let day = 30 ; 
%else %let day=29;

%if (%qupcase(&month) = JAN)  %then %let mon=1;
%else %if (%qupcase(&month)= FEB) %then %let mon=2;
%else %if (%qupcase(&month) = MAR) %then %let mon=3;
%else %if (%qupcase(&month) = APRIL) %then %let mon=4;
%else %if (%qupcase(&month) = MAY) %then %let mon=5;
%else %if (%qupcase(&month) = JUNE) %then %let mon=6;
%else %if (%qupcase(&month) = JULY) %then %let  mon = 7;
%else %if (%qupcase(&month)= AUGUST) %then %let mon = 8;
%else %if ( %qupcase(&month)= SEPT) %then %let mon = 9;
%else %if ( %qupcase(&month)= OCT) %then %let mon = 10;
%else %if ( %qupcase(&month)= NOV) %then %let mon = 11;
%else %if (%qupcase(&month) = DEC ) %then %let mon=12;
%else %do;
    put "Invalid month, Please input month = Jan, Feb,Mar.... Nov Dec ";
	%abort;
	%end;

/*e.g. 20140701.log*/
%do i=5 %to 5 ;
		%if &mon le 9 %then %do;
			%if &i le 9 %then %do;
			data &month.d&i.  ;
			infile " \\censeadfsp09\SASTemp\log&year.0&mon.\&year.0&mon.0&i..log  " lrecl=2000 dsd truncover delimiter= " ";
			input   IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
			posit = 1 ;
			Exact_site="KP1";
				run;
			%end;
			%else %do;
        	data &month.d&i. ;
			infile " \\censeadfsp09\SASTemp\log&year.0&mon.\&year.0&mon.&i..log "  lrecl=2000 dsd truncover delimiter= " ";
			input  IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
			posit = 1 ;
			Exact_site="KP1";
			run;
		   %end;
		   %end;
		%else %do;
			%if &i le 9 %then %do;
			data &month.d&i._&j ;
			infile " \\censeadfsp09\SASTemp\log&year.&mon.\&year.&mon.0&i..log " lrecl=2000 dsd truncover delimiter= " ";
			input  IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
			posit = 1 ;
			Exact_site="KP1";
				run;
			%end;
			%else %do;
        	 data &month.d&i._&j  ;
			infile " \\censeadfsp09\SASTemp\log&year.&mon.\&year.&mon.&i..log " lrecl=2000 dsd truncover delimiter= " ";
			input  IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
			posit = 1 ;
			Exact_site="KP1";
			run;
		   %end;
	%end;
%end;

/* e.g. 20140731_1.log */
%do i=5 %to 5;
	%do j=1 %to &n; 
		%if &mon le 9 %then %do;
			%if &i le 9 %then %do;
			data &month.d&i._&j;
			infile " \\censeadfsp09\SASTemp\log&year.0&mon.\&year.0&mon.0&i._&j..log  " lrecl=2000 dsd truncover delimiter= " ";
			input  IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
			if %eval(&j) < 4 then do;
					posit = 1;
					if %eval(&j)= 1 then Exact_site="KP1";
					else Exact_site="KP2";
				end;
				else do;
					posit=2;
					If %eval(&j) < 4 then Exact_site="SP1";
					else Exact_site="SP2";
				end;
			run;
			%end;
			%else %do;
        	data &month.d&i._&j  ;
			infile " \\censeadfsp09\SASTemp\log&year.0&mon.\&year.0&mon.&i._&j..log " lrecl=2000 dsd truncover delimiter= " ";
			input IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
				if %eval(&j) < 4 then do;
					posit = 1;
					if %eval(&j)= 1 then Exact_site="KP1";
					else Exact_site="KP2";
				end;
				else do;
					posit=2;
					If %eval(&j) < 4 then Exact_site="SP1";
					else Exact_site="SP2";
				end;
			run;
		   %end;
		   %end;
		%else %do;
			%if &i le 9 %then %do;
			data &month.d&i._&j  ;
			infile " \\censeadfsp09\SASTemp\log&year.&mon.\&year.&mon.0&i._&j..log " lrecl=2000 dsd truncover delimiter= " ";
			input IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
		  		if %eval(&j) < 4 then do;
					posit = 1;
					if %eval(&j)= 1 then Exact_site="KP1";
					else Exact_site="KP2";
				end;
				else do;
					posit=2;
					If %eval(&j) < 4 then Exact_site="SP1";
					else Exact_site="SP2";
				end;
				run;
			%end;
			%else %do;
        	 data &month.d&i._&j  ;
			infile " \\censeadfsp09\SASTemp\log&year.&mon.\&year.&mon.&i._&j..log " lrecl=2000 dsd truncover delimiter= " ";
			input  IP: $ 32. +5 Date date11.  +1 Time  time8. +1 unknown0: $6.
		              +1 Request_type  : $4.   Request:  $ 200. unknown1 :$7.
					   Status: 3. unknown2 :$10. Referer :$300. 
					  Agent :  $500. Session_id: $200. unknown3 :$10 ;
				if %eval(&j) < 4 then do;
					posit = 1;
					if %eval(&j)= 1 then Exact_site="KP1";
					else Exact_site="KP2";
				end;
				else do;
					posit=2;
					If %eval(&j) < 4 then Exact_site="SP1";
					else Exact_site="SP2";
				end;
			run;
		   %end;
		%end;
	%end;
%end;



%mend input_log;

%macro input_modify ( year, month , n );


%input_log( &year, &month, &n ) 
 *proc append to achieve the most efficiency;
%do i=5 %to 5;
	%do j=1 %to &n;
proc append base=&month.d&i. data= &month.d&i._&j.;
run;

proc datasets library=work;
   delete 
			&month.d&i._&j;
run;

	%end;	

%end;



%do k=5 %to 5;
data &month._d&k. (compress=yes);
length classification $ 35 class $ 25 ;
*format class_ind1 class_ind2 $class.; 
if _n_= 1 then do i=1 to nobs ; * create look up table for spider;
	set files.spiderlist nobs= nobs;
	array s{24}$ 40 _temporary_;
	s[i] = host ;
end;	
if _n_=1 then do; * create the hash object for classify;
	set files.classify;
	declare hash classifi (dataset : " files.classify" );
	classifi.definekey( "Result");
	classifi.definedata("Class") ;
	classifi.definedone(); 
end;
set &month.d&k. (drop =  unknown1 unknown2 unknown3 ) ;
if 0 ^= find(Request ,'?') then  do;							/*with para*/
		Request_file=scan(Request,1,'?'); 
		query=substr(Request,find(Request ,'?')+1);
	    if 'param=b5'  = substr(query ,1,8)	then	 do;			/*simplied chinese*/
		       	if 0 ^= find(query ,'?') then do;		/* simplied chinese with para*/				
					request_file=scan(substr(query ,find(query,'censtatd.gov.hk/')+15),1,'?');
					query=substr(query,find(query ,'?')+1);
				end;		/*end simplied chinese with para*/
				else  do; /* simplied chinese without para*/
					request_file=substr(query ,find(query,'censtatd.gov.hk/')+15);
					query='"';
				end; /*end simplied chinese without para*/
		end;  /*end simplied chinese*/
	end;	 /*end with para*/
else request_file=Request ; /*no file requested*/


*some http request may include domain, replace it by /;
request_file = tranwrd(request_file,"http://www.censtatd.gov.hk/","/");
request_file = tranwrd(request_file,"https://www.censtatd.gov.hk/","/");
request_file = tranwrd(request_file,"http://censtatd.gov.hk/","/");
request_file = tranwrd(request_file,"https://censtatd.gov.hk/","/");

*some http request may include //, replace it by /;
request_file = tranwrd(request_file,"//","/");
* create the class indicator;

* using hash object  classification ;

if find(query,"productType=8")>0 and find(request_file,"/hkstat/sub/sp")>0  then classification = "HTML";
else if find(query,"productType=9")>0 and find(request_file,"/hkstat/sub/sp")>0 then classification = "Chart";
else if ( find(query,"productCode=")>0 and find(request_file,"/hkstat/sub/sp")>0) or (find(query,"productCode=")>0 and find(request_file,"/hkstat/sub/sc")>0)  then classification = "productpage";

if classification= "" then do;
rc = classifi.find( key : substr(request_file,1,17));
if rc = 0 then classification= class;

rc= classifi.find ( key: substr(request_file,1,14));
if rc=0 then classification = class;

rc=classifi.find( key : substr(request_file,1,33));
if rc=0 then classification = class;

rc=classifi.find( key : substr(request_file,1,15) );
if rc=0 then classification = class;

rc=classifi.find( key : substr(request_file,1,11));
if rc=0 then classification = class;

rc= classifi.find( key : substr(request_file,1,3) );
if rc=0 then classificaton = class;

rc= classifi.find(  key : request_file);
if rc=0 then classification =class;
end;


* keep necessary attributes;
drop Request unknown1 unknown2 unknown3 Request_type  k i host  result class spiderT host unknown0 rc; /*http_version*/  

/* check the existence of spider* if not exist = 0 */
spiderT=0 ;
do k=1 to nobs; /*look up*/
	if  find( Agent, s[k] )>0 then spiderT=1;
end;

*select required file and ip to put into PDV and process;
	where IP ^ in ('2406:0:58:8080:10:88:139:2' 
					,'2406:0:58:8080:10:88:139:3' 
					,'10.88.139.2' 
					,'10.88.139.3')  
	 and status in (200,302,304);
	 if spiderT=0 
and request_file ^ in ('/feed.jsp' ,
									'/tooptip_content.jsp' ,
									'/hkhs_tradecodesection_inc.jsp',
									'/press_release/pressReleaseCode.jsp',
									'/full_hierarchy_writeNodes.jsp',
									'/head_js.jsp'
									)
and  ( substr(request_file,length(request_file)) = '/'
			   or  (substr(request_file ,IFN(length(request_file)-4+1>0,length(request_file)-4+1,1))='.jsp'  ) 
			   or  (substr(request_file ,IFN(length(request_file)-4+1>0,length(request_file)-4+1,1))='.htm'  ) 
			   or  (substr(request_file ,IFN(length(request_file)-4+1>0,length(request_file)-4+1,1))='.pdf'  ) 
			   or  (substr(request_file ,IFN(length(request_file)-4+1>0,length(request_file)-4+1,1))='.doc'  ) 
			   or  (substr(request_file ,IFN(length(request_file)-4+1>0,length(request_file)-4+1,1))='.xls'  ) 
			   or  (substr(request_file ,IFN(length(request_file)-4+1>0,length(request_file)-4+1,1))='.eft'  ) 
	 		   or  (substr(request_file ,IFN(length(request_file)-5+1>0,length(request_file)-5+1,1))='.html'  ) 
		   ) 

		   then output;
	 
run;

%include "\\censeadfsp09\SASTemp\yclam1\derive_sessionID.sas";		

proc datasets library= WORK;
delete  &month.d&k.;
run;

%end;



%mend input_modify;

%macro combine_and_output(year=2014, month=August,  date = . , duration=month , start = 0 , end=0 );
  %let x=%substr(&year ,3,2);

%let serial = %substr( %eval( 100+&mon), 2,2 ) ; 

	%macro spider_host(year,month); 
	data &month..spider;
	infile "\\censeadfsp09\SASTemp\log&year.&serial.\spiderhost.txt" ;
	input ip : $50. ;
	run;
	%mend spider_host;

	%spider_host(&year, &month)

	data &month..y&x.&serial.;
	set &month..y&x.m&serial.d1;
	run;

%if &duration = month %then %do;

	%do k=2 %to &day;
	proc append base=&month..y&x.&serial. data=	&month..y&x.m&serial.d&k.;
	run;
	%end;

    %let datafile =&month..y&x.&serial.;
	%include "\\censeadfsp09\SASTemp\yclam1\Output.sas";		
%end;
%else %do;
	%let datafile=&month..y&x.m&serial.d&date.;
    %include "\\censeadfsp09\SASTemp\yclam1\Output.sas";	
%end;



%mend combine_and_output;




* derive session + classify = input_modify ;
%input_modify( 2014, August , 7)

* combine = {month or 1 day} + run&output;
%combine_and_output ( year=2014, month= August , duration =month, start =2, end=40);





 


