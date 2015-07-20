
Options COMPRESS=YES; 

%let x=%substr(&year ,3,2);
%let serial = %substr( %eval( 100+&mon), 2,2 ) ; 



	data test ; 
	format  time time8. date date9.;
	set &month._d&k.  ;
	run;

/* compare the number of unique session_id existing before and after the derive ;
proc sql;
select count(distinct session_id ) from test;
quit;
*/


/*[Used cartesian to compare record]*/
	proc sort data=test;
	by ip date time;
	run;
/**join two tables: one only with first. ip's record  and others with all records( include the first.ip 's record) **/
	data test2;
	set test;
	by ip date time;
	if first.ip then output;
	run;

	proc sql;
	create table test3 as
	select b.agent as bagent, b.Referer as breferer ,b.classification as bclass, a.session_id,  b.ip as bip,b.time as btime, b.session_id as BID, b.posit, b.exact_site ,b.query as bquery from test2 as a , TEST as b
	where a.ip=b.ip and a.date = b.date;
	quit;

/*[/Used cartesian to compare record]*/

/* descending sort to impute the missing first.ip 's records */
	proc sort data=test3;
	by bip descending btime ;
	run;

	data test5(compress=yes) ;
	format btime last_time impute_time time8.;
	length session_id_step0 session_id_step1 $ 200;
	set test3 (rename=(bip = ip));
	by ip descending btime;
* retain for the situation where the first few records' session_id are missing ;
	retain _Rsession_id;
* Creating variables with Lag function;
	session_id = bid;
	session_id_step0 = bid;
	last_bid=lag(bid);
	impute_id=lag(last_bid);
	last_site=lag(posit);
	last_time=lag(btime);
	impute_time=lag(last_time);
	last_site=lag(posit);
* this two variables are to double check and avoid taking record from different ip. ;
	last_ip= lag(ip);
	impute_ip= lag(last_ip);
	diff =abs( round( ( btime - last_time )/60 ));
	last_agent=lag(bagent);
* first.ip should have diff =. ;
	if first.ip then diff=.;

*imputeing the body: impute body before first.ip's record because imputing the body can extend records closer to the first.ip's record;
* if not first.ip and last.ip and session_id is missing then take the last_id;
* time difference<30;
*if last_id is missing then take impute_id if and only if impute_ip = ip and time difference beterrn last_ and impute_ also  <30;
	if first.ip =0 and last.ip = 0   and session_id = '-' and posit=last_site and bagent = last_agent then do;
		if  last_bid not eq '-'  and diff =< 30  then session_id = last_bid;
		if   last_bid eq '-' and round(( impute_time - last_time )/60) =< 30  and ip = impute_ip then session_id = impute_id;
	end;
*impute the last.ip i.e. first ip if missing ; 
* assign last id to current id if missing / only applicable for last.ip ( i.e. first ip sorted by descending);
* if not missing then retain the session_id;
	if session_id not eq '-' then _Rsession_id = session_id;
*if first.ip or last.ip or overtime and clear the retaining session_id;
	if first.ip or last.ip or diff >30 then _Rsession_id = '-';
*if last.ip and not first. ip => exclude oberservation of one ip with one record only;
* if time difference <30 and same ip then we take the last_id;
	if last.ip and not first.ip and diff =< 30 and session_id = "-" and bagent = last_agent  then do;
		if last_bid not eq '-' then session_id = last_bid;
* prevent from taking id from different IP ;
* if missing then take the impute_id;
		else if  last_bid = '-' and impute_id not eq '-' and round(( impute_time- last_time)/60) >= -30 and ip = impute_ip then session_id = impute_id;
* if first few records missing , then take the retained id;
* the restriction of retaining prevent taking invalid id.;
	else if impute_id eq '-' then session_id = _Rsession_id ;
	end;
	session_id_step1 = session_id;
	drop last_site _Rsession_id last_bid impute_id  last_time impute_time last_ip impute_ip diff last_agent;
	run;

/*acsending sort to impute the missing body's records */
	proc sort data=test5 out=test6 (drop=bid time );
	by ip btime ;
	run;

	data test7(compress=yes)  ;
	set test6 (rename=(bagent=agent));
	by ip btime;
	format impute_time trible_time time8.;
	length session_id_step1 $ 200 session_id_step2 $ 200;
* retaining session_id in case of consecutive missing;
	retain _session_id;
* Assigning variables with Lag function;
	last_ip= lag(ip);
	impute_ip= lag(last_ip);
	trible_ip = lag(impute_ip);
	diff=lag(diff);
	last_bid=lag(session_id);
	impute_diff= lag(diff);
	impute_id = lag(last_bid);
	last_time=lag(btime);
	impute_time=lag(last_time);
	trible_time=lag(impute_time);
	last_site=lag(posit);
	impute_site=lag(last_site);
	last_agent=lag(bagent);
	if posit not eq last_site then mark = "Change_site";
* retain only when session_id is not missing;
	if session_id not eq '-' then _session_id = session_id;
* for body's record, if session_id is missing and diff<30 and impute_diff not eq. <= not allow the second record of the same IP from taking value of another ip. ;
	if not first.ip  and session_id = '-' and (diff =< 30)  and impute_diff not eq . and posit = last_site and agent=last_agent then do; 
* take the last_id;
		session_id = last_bid;
* if last_id is missing;
		if last_bid = '-' then do;
* take impute_id if and only if ip=impute_id and time difference <30;
			if impute_diff =< 30 and ip = impute_ip and round((last_time - impute_time)/60) < 30  and impute_site = posit then session_id = impute_id;
		end;
	end;
* restrict the retaining;
	if first.ip or last.ip or diff >30 or mark="Change_site"  then _session_id = '-';
	if not first.ip and agent not eq last_agent then _session_id = '-';
* if session_id is still missing after the above imputation;
	if session_id = '-' then do;
* take the retaining id;
		session_id = _session_id;
* defensive: check against the impute_ip;
		if ip not eq trible_ip  then session_id = '-' ;
	end;
	session_id_step2= session_id;
	keep btime ip session_id posit agent breferer bclass bquery session_id_step2 session_id_step1 session_id_step0;
	run;

* all blanks that could be imputed are imputed;
	data test9 miss ;
	set test7  (rename=(breferer=referer bclass=classification bquery=query )) ;
	 if session_id = '-' then output miss;
	else output test9;
	run;
* separate operation for missing sesion_id's record and valid session_id's record;

proc sort data=test9 out=test11;
by ip btime;
run;


data test11a(compress=yes) ;
length mark $ 30 ip $ 32 Session_id $ 200 agent last_agent $ 500;
set test11 ;
by ip btime;
last_ip= lag(ip);
last_bid=lag(session_id);
last_time=lag(btime);
last_agent=lag(agent);
diff=round((btime-last_time)/60) ;
last_site=lag(posit);
if first.ip then diff = .;
if posit not eq last_site and session_id = last_bid and not first.ip and agent = last_agent and diff <30 then mark= "change_site";
else if not first.ip and posit not eq last_site then mark="possible_change";
if not first.ip and diff>30 and session_id = last_bid then mark="overtime_but_same_id";
drop last_site last_bid last_ip last_time last_agent diff;
run;

proc sort data=test11a out=test11b;
by ip descending btime;
run;

data test11c(compress=yes) ;
length session_id_step3 $ 200;
set test11b;
by ip descending btime;
last_time=lag(btime);
diff=round((btime-last_time)/60) ;
last_Rbid=lag(session_id);
if not first.ip and mark="overtime_but_same_id" and diff < 30 then session_id = last_Rbid;
drop diff last_Rbid last_time;
session_id_step3= session_id;
run;

proc sort data=test11c out=test12;
by ip btime;
run;

data test12a(compress=yes) ;
set test12;
by ip btime;
last_time=lag(btime);
diff=round((btime-last_time)/60) ;
last_site=lag(posit);
last_bid=lag(session_id);
last_agent=lag(agent);
impute_site=lag(last_site);
last_mark=lag(mark);
last_ip=lag(ip);
impute_ip=lag(last_ip);
if not first.ip and diff<30 and posit not eq last_site and session_id not eq last_bid and agent eq last_agent and ip=impute_ip  and posit = impute_site then mark="consecutive_jump";
drop last_mark last_site last_bid last_agent impute_site last_time diff last_ip impute_ip ;
run;

data test12b(compress=yes) ;
set test12a;
by ip btime;
last_time=lag(btime);
last_mark=lag(mark);
last_bid=lag(session_id);
last_agent=lag(agent);
last_site=lag(posit);
impute_site=lag(last_site);
diff=round((btime-last_time)/60) ;
last_ip=lag(ip);
impute_ip=lag(last_ip);
if not first.ip and posit eq last_site and posit eq impute_site and session_id not eq last_bid  and diff <30  and  ip=impute_ip and last_mark not eq "consecutive_jump" then mark = "Reopen_browser";
drop last_mark last_agent last_bid last_nt last_site impute_site last_time diff  last_ip impute_ip;
run;

data &month..y&x.m&serial.d&k. (compress=yes) ;
set test12b (rename=(btime=time));
by ip time;
retain _session_id;
last_mark=lag(mark);
last_time=lag(time);
diff=round((time-last_time)/60) ;
if first.ip or diff > 30 or mark="Reopen_browser"  then _session_id = session_id;
drop last_mark last_time diff ;
run;

proc sort data=miss out=miss2;
by ip btime;
run;

data &month..y&x.m&serial.d&k.miss (compress=yes rename=(btime=time ));
length mark $ 30 _session_id $ 200 agent $ 500;
set miss2 ;
by ip;
last_time= lag(btime);
last_ip= lag(ip);
last_site=lag(posit);
diff = round( (btime-last_time)/60) ;
last_agent=lag(agent);
if first.ip then do;
	diff =. ;
	count + 1 ;
end;
if first.ip or diff > 30 then i+1;
_session_id=trim(right(put( i, 8.))) !! trim( &k);
drop last_time last_ip last_site mark last_agent i diff ;
run;

proc sql;
title ' after retain';
select count(distinct _session_id ) from August.y14m08d5;
quit;

proc sql;
title ' missing of after retain';
select count(distinct _session_id ) from August.y14m08d5miss;
quit;

proc append base=&month..y&x.m&serial.d&k. data=&month..y&x.m&serial.d&k.miss force;
run;

proc sql;
title ' after append';
select count(distinct _session_id ) from August.y14m08d5;
quit;
/*
proc datasets library=WORK;
   delete 
			 test
			 test2
			 test3
			 test4
			 test5
			 test6
			 test7
			 test8
			 test9
			 test10
			 test11
			 test11a
			 test11b
			 test11c
			 test12
			 test12b
			 test12c
			 test12a
			 miss
              miss2
              &month._d&k.;
run;









          








		