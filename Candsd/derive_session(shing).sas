* re-generate session id ; 
*sort by ip and date time desc;
proc sort data=&day_data;
by ip descending date descending  time ;
run;

*derive variable for comparison;
Data &day_data;  *(drop=status_code referrer useragent request_file query isspider);
set &day_data; 
	datetime= DHMS(MDY(month(date),day(date),year(date)),hour(time),minute(time),second(time)); *combine the time for easier comparion;
    last_ip= lag(ip) ;
    last_sessionid=lag(sessionid);
	last_datetime = lag(datetime);
	*obsno = _N_;
	sessionid_original=sessionid;
run;
*fill the sessionid of entry page, 	  since more than half of the entry page do not have session id;
* also fill the previous page that last_datetime - datetime <=1800 and  sessioin id is '-' ;
Data &day_data;
set &day_data; 
if _N_ >1 and sessionid='-' and ip=last_ip and  last_datetime - datetime <=1800 then 
	do;
		if last_sessionid= '-' then sessionid =symget('last_sessionid_used');
		else sessionid =last_sessionid;	
		if last_sessionid ^= '-' then call symput('last_sessionid_used', last_sessionid);
	end;
	
	if ip^=last_ip then call symput('last_sessionid_used', '-');
	*last_sessionid_used = symget('last_sessionid_used');
	last_sessionid = lag(sessionid);
run;

/* <--old method
*fill the sessionid of entry page, 	since more than half of the entry page do not have session id;
Data &day_data;
set &day_data; 
if _N_ >1 and sessionid='-' and ip=last_ip and  last_datetime - datetime <=1800 then 
	do;
		sessionid =last_sessionid;	
	end;
last_sessionid = lag(sessionid);
run;
old method-->
*/

*assign sessionid group ;
Data &day_data;
set &day_data; 
retain newsessionid;
	if _N_ = 1 then newsessionid =1;
	else do;
		if ^(	(sessionid  ^="-"  and sessionid = last_sessionid) or
		   		(sessionid  ="-"  and ip = last_ip and  last_datetime - datetime <=1800)  or 
		   		(sessionid  ^="-"  and sessionid ^= last_sessionid and last_sessionid ='-' and ip = last_ip and  last_datetime - datetime <=1800) 
			)
		then do;
			newsessionid=newsessionid+1;
		end;
		else if sessionid='-' then	sessionid=last_sessionid;			
	end;
run;

* fix the sessionid with more than one newsessionid  (assign the min newsessionid for the same sessionid);
proc sort data=&day_data;
by  sessionid newsessionid;
run;

Data &day_data; 
set &day_data; 
if _N_ =1 then do;
	call symput('last_newsessionid',newsessionid);
	call symput('last_sessionid',sessionid);
	new_newsessionid = newsessionid;
end;
else if sessionid = '-' then
	new_newsessionid = newsessionid;
	else do;
			if sessionid = symget('last_sessionid') then new_newsessionid = symget('last_newsessionid');
			else do ;
				call symput('last_newsessionid',newsessionid);
				new_newsessionid = newsessionid;
			end;
			call symput('last_sessionid',sessionid);
		end;
run;
/* <--old method
Data minnewsession (keep= sessionid new_newsessionid) ;
set &day_data; 
by sessionid;
if 1 =first.sessionid and sessionid ^= "-" then output ;
rename newsessionid =new_newsessionid;
run;

Data &day_data; 
merge &day_data(in=a) minnewsession(in=b); 
by sessionid;
if b=0 then new_newsessionid= newsessionid;
run;
old method -->
*/

/*
proc sort data=&day_data;
by ip descending date descending  time ;
run;
*/