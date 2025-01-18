data employee_data;
input emp_id emp_name$ salary performance_rating dept$;
cards;
101 sam 75000 4 it
102 shiv 60000 3 hr
103 dany 50000 2 sales
104 sanaya 30000 5 intern
105 noel 80000 3 senior dev
;
run;


data performance_data;
input emp_id promotion_eligible$;
cards;
101 yes
104 yes
102 yes
;
run;


proc sort data = employee_data;
by emp_id;
run;

proc sort data=performance_data out=per_data;
by emp_id;
run;

data merge_data;
merge employee_data(in=a) per_data(in=b);
by emp_id;
run;

data compensation_report;
set merge_data;
length performance_level$ 10;

if performance_rating >=4 then do;
   performance_level = "EXCELENT";
   bonus = salary * 0.20;
end;

else if performance_rating = 3 then do;
    performance_level = "GOOD";
	bonus = salary * 0.10;
end;

else do;
    performance_level = "average";
	bonus = salary * 0.05;
end;

run; 

data final_compensation;
set compensation_report;
additional_bonus = 0;
count = 1;
do until (additional_bonus>=3000);
additional_bonus+1000;
count+1;
end;

total_compensation = salary+bonus+additional_bonus;
drop count;
run;

proc print data =final_compensation;
var emp_id emp_name salary performance_rating dept promotion_eligible performance_level bonus total_compensation;

format total_compensation dollar10.2;
title "emp Performance report";
run;
