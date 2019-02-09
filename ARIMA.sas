proc import datafile = "/home/njd130/IAQF Financial Engineering Competition/ARIMA/creditspreads.csv"
	out = spreads
	dbms = csv replace;
run;

proc arima data = spreads (obs = 5000);
identify var = cs13;
identify var = cs13(1);
identify var = cs13(1,1);
run;

proc arima data = spreads(obs = 5000);
identify var = cs13(1);
*estimate q = 1 method = ml;
*estimate p = 1 method = ml;
*estimate q = 2 method = ml;
*estimate p = 2 method = ml;
*estimate q = 3 method = ml;
*estimate p = 3 method = ml;
estimate p = 1 q = 1 method = ml;
estimate p = 1 q = 2 method = ml;
estimate p = 1 q = 3 method = ml;
estimate p = 2 q = 1 method = ml;
estimate p = 2 q = 2 method = ml;
estimate p = 2 q = 3 method = ml;
estimate p = 3 q = 1 method = ml;
estimate p = 3 q = 2 method = ml;
estimate p = 3 q = 3 method = ml;
run;

proc arima data = spreads(obs=5000);
identify var = cs13(1);
estimate p = 3 q = 3 noconstant method = ml;
forecast out = resids lead = 0;
run;

data resids;
set resids;
id = _n_;
run;

proc sgplot data=resids;
   series x=id y=cs13 / legendlabel="spread";
   series x=id y=forecast / legendlabel="forecast";
run;

proc sgplot data = resids;
loess x = forecast y = residual;
run;