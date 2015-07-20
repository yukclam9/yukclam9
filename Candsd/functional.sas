libname files  "\\censeadfsp09\SASTemp\Program_Product_basket_analysis\ ";
run;
/*

data files.spiderlist;
length host $ 40;
input host $40. ;
datalines;
gsa-crawler 
bot
spider 
yahoo! slurp
wget
suntek
hanweb
scoutjet
simplepie
twitterfeed
feedly
windows-rss
feedfetcher
perl lwp
link sleuth
servers alive url check
powermarks
check&get
crawler
python-urllib
xianguo.com
yahoo pipes
larbin
libwww-perl
;
run;


data files.classify  ;
input Result : $ 200.   @40 Class  $ 25. ;
datalines;
/hkstat/sub/so454                          SO_Lv 2,3
/hkstat/sub/so453                          SO_Lv 2,3
/hkstat/sub/so452                          SO_Lv 2,3
/hkstat/sub/so450                          SO_Lv 2,3
/hkstat/sub/so440                          SO_Lv 2,3
/hkstat/sub/so430                          SO_Lv 2,3
/hkstat/sub/so420                          SO_Lv 2,3
/hkstat/sub/so410                          SO_Lv 2,3 
/hkstat/sub/so400                          SO_Lv 2,3
/hkstat/sub/so390                          SO_Lv 2,3
/hkstat/sub/so380                          SO_Lv 2,3
/hkstat/sub/so370                          SO_Lv 2,3
/hkstat/sub/so360                          SO_Lv 2,3
/hkstat/sub/so350                          SO_Lv 2,3
/hkstat/sub/so340                          SO_Lv 2,3
/hkstat/sub/so330                          SO_Lv 2,3
/hkstat/sub/so320                          SO_Lv 2,3
/hkstat/sub/so310                          SO_Lv 2,3
/hkstat/sub/so300                          SO_Lv 2,3
/hkstat/sub/so290                          SO_Lv 2,3
/hkstat/sub/so280                          SO_Lv 2,3
/hkstat/sub/so270                          SO_Lv 2,3
/hkstat/sub/so260                          SO_Lv 2,3
/hkstat/sub/so250                          SO_Lv 2,3
/hkstat/sub/so240                          SO_Lv 2,3
/hkstat/sub/so230                          SO_Lv 2,3
/hkstat/sub/so220                          SO_Lv 2,3
/hkstat/sub/so210                          SO_Lv 2,3
/hkstat/sub/so200                          SO_Lv 2,3
/hkstat/sub/so190                          SO_Lv 2,3
/hkstat/sub/so180                          SO_Lv 2,3
/hkstat/sub/so170                          SO_Lv 2,3
/hkstat/sub/so160                          SO_Lv 2,3
/hkstat/sub/so150                          SO_Lv 2,3
/hkstat/sub/sp454                          SP_Lv 2,3
/hkstat/sub/sp453                          SP_Lv 2,3
/hkstat/sub/sp452                          SP_Lv 2,3
/hkstat/sub/sp450                          SP_Lv 2,3
/hkstat/sub/sp440                          SP_Lv 2,3
/hkstat/sub/sp430                          SP_Lv 2,3
/hkstat/sub/sp420                          SP_Lv 2,3
/hkstat/sub/sp410                          SP_Lv 2,3
/hkstat/sub/sp400                          SP_Lv 2,3
/hkstat/sub/sp390                          SP_Lv 2,3
/hkstat/sub/sp380                          SP_Lv 2,3
/hkstat/sub/sp370                          SP_Lv 2,3
/hkstat/sub/sp360                          SP_Lv 2,3
/hkstat/sub/sp350                          SP_Lv 2,3
/hkstat/sub/sp330                          SP_Lv 2,3
/hkstat/sub/sp320                          SP_Lv 2,3
/hkstat/sub/sp310                          SP_Lv 2,3
/hkstat/sub/sp300                          SP_Lv 2,3
/hkstat/sub/sp290                          SP_Lv 2,3
/hkstat/sub/sp280                          SP_Lv 2,3
/hkstat/sub/sp270                          SP_Lv 2,3
/hkstat/sub/sp260                          SP_Lv 2,3
/hkstat/sub/sp250                          SP_Lv 2,3
/hkstat/sub/sp240                          SP_Lv 2,3
/hkstat/sub/sp230                          SP_Lv 2,3
/hkstat/sub/sp220                          SP_Lv 2,3
/hkstat/sub/sp210                          SP_Lv 2,3
/hkstat/sub/sp200                          SP_Lv 2,3
/hkstat/sub/sp190                          SP_Lv 2,3
/hkstat/sub/sp180                          SP_Lv 2,3
/hkstat/sub/sp170                          SP_Lv 2,3
/hkstat/sub/sp160                          SP_Lv 2,3
/hkstat/sub/sp150                          SP_Lv 2,3
/hkstat/sub/sc454                          SC_Lv 2,3
/hkstat/sub/sc453                          SC_Lv 2,3
/hkstat/sub/sc452                          SC_Lv 2,3
/hkstat/sub/sc450                          SC_Lv 2,3
/hkstat/sub/sc440                          SC_Lv 2,3
/hkstat/sub/sc430                          SC_Lv 2,3
/hkstat/sub/sc420                          SC_Lv 2,3
/hkstat/sub/sc410                          SC_Lv 2,3
/hkstat/sub/sc400                          SC_Lv 2,3
/hkstat/sub/sc390                          SC_Lv 2,3
/hkstat/sub/sc380                          SC_Lv 2,3
/hkstat/sub/sc370                          SC_Lv 2,3
/hkstat/sub/sc360                          SC_Lv 2,3
/hkstat/sub/sc350                          SC_Lv 2,3
/hkstat/sub/sc330                          SC_Lv 2,3
/hkstat/sub/sc320                          SC_Lv 2,3
/hkstat/sub/sc310                          SC_Lv 2,3
/hkstat/sub/sc300                          SC_Lv 2,3
/hkstat/sub/sc290                          SC_Lv 2,3
/hkstat/sub/sc280                          SC_Lv 2,3
/hkstat/sub/sc270                          SC_Lv 2,3
/hkstat/sub/sc260                          SC_Lv 2,3
/hkstat/sub/sc250                          SC_Lv 2,3
/hkstat/sub/sc240                          SC_Lv 2,3
/hkstat/sub/sc230                          SC_Lv 2,3
/hkstat/sub/sc220                          SC_Lv 2,3
/hkstat/sub/sc210                          SC_Lv 2,3
/hkstat/sub/sc200                          SC_Lv 2,3
/hkstat/sub/sc190                          SC_Lv 2,3
/hkstat/sub/sc180                          SC_Lv 2,3
/hkstat/sub/sc170                          SC_Lv 2,3
/hkstat/sub/sc160                          SC_Lv 2,3
/hkstat/sub/sc150                          SC_Lv 2,3
/hkstat/sub/ss454                          SS_Lv 2,3
/hkstat/sub/ss453                          SS_Lv 2,3
/hkstat/sub/ss452                          SS_Lv 2,3
/hkstat/sub/ss450                          SS_Lv 2,3
/hkstat/sub/ss440                          SS_Lv 2,3
/hkstat/sub/ss430                          SS_Lv 2,3
/hkstat/sub/ss420                          SS_Lv 2,3
/hkstat/sub/ss410                          SS_Lv 2,3
/hkstat/sub/ss400                          SS_Lv 2,3
/hkstat/sub/ss390                          SS_Lv 2,3
/hkstat/sub/ss380                          SS_Lv 2,3
/hkstat/sub/ss370                          SS_Lv 2,3
/hkstat/sub/ss360                          SS_Lv 2,3
/hkstat/sub/ss350                          SS_Lv 2,3
/hkstat/sub/ss330                          SS_Lv 2,3
/hkstat/sub/ss320                          SS_Lv 2,3
/hkstat/sub/ss310                          SS_Lv 2,3
/hkstat/sub/ss300                          SS_Lv 2,3
/hkstat/sub/ss290                          SS_Lv 2,3
/hkstat/sub/ss280                          SS_Lv 2,3
/hkstat/sub/ss270                          SS_Lv 2,3
/hkstat/sub/ss260                          SS_Lv 2,3
/hkstat/sub/ss250                          SS_Lv 2,3
/hkstat/sub/ss240                          SS_Lv 2,3
/hkstat/sub/ss230                          SS_Lv 2,3
/hkstat/sub/ss220                          SS_Lv 2,3
/hkstat/sub/ss210                          SS_Lv 2,3
/hkstat/sub/ss200                          SS_Lv 2,3
/hkstat/sub/ss190                          SS_Lv 2,3
/hkstat/sub/ss180                          SS_Lv 2,3
/hkstat/sub/ss170                          SS_Lv 2,3
/hkstat/sub/ss160                          SS_Lv 2,3
/hkstat/sub/ss150                          SS_Lv 2,3
/hkstat/sub/so                               SO_Lv 1
/hkstat/sub/sp                               SP_Lv 1
/hkstat/sub/sc                               SC_Lv 1
/hkstat/sub/ss                               SS_Lv 1
/trader/hscode/                             HS code
/hkhs_tradecodesection_inc.jsp            HS code
/press_release/pressReleaseDetail         Press_release_Detail
/press_release/                             Press_release
/hkstat/sub/bbs                             bbs 
/hkstat/srh                                    Product_search
/hkstat/quicklink                           Quicklink
/                                                  Root
//                                                 Root
/home.html                                   Root
/index.htm                                    Root
/index.html                                   Root
/index.jsp                                     Root
/fd.jsp                                          freedownload
/freedownload.jsp                         freedownload
/free_dl_gov_book.jsp                  freedownload
/showtableexcel2.jsp                    Download_HTML
/showtableexcel_sc.jsp                 Download_HTML
/showtablecsv.jsp                         Download_HTML
/showtablecsv_sc.jsp                    Download_HTML
/showtablecust.jsp                        Table_customisation
/m/                                              Mobile
/ssl/customer_feedback_form.jsp            Feedback_form
/ssl/reg_form.jsp                           Reg_form
;
run;
*/




data files.productlist(compress=yes) ;   
	infile "\\censeadfsp09\SASTemp\Program_Product_basket_analysis\productlist.txt"
	  line=Linept col=Columnpt lrecl=2000 	truncover  	delimiter="," dsd  
	firstobs=2  ;
	input url :$50.   productcd :$30. ; 
run;

proc import datafile="\\censeadfsp09\SASTemp\Program_Product_basket_analysis\mapping01.csv"
	    out=files.mapping
		dbms=csv
		replace;
	run;

	data files.mapping;
	set files.mapping;
	trim_value= trim(code) !! ":" !!  trim(tableno);
	run;







