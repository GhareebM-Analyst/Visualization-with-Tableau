

  
-- The code below will generate View tables contains country's cases related information aggregated by month.
Drop view  if exists wolrd_data;
CREATE VIEW wolrd_data as
with summary(iso_code,date,total_cases,total_deaths) as (
SELECT distinct iso_code, 
DATE_FORMAT(case_date, '%Y-%m') as date,
sum(new_cases) over (partition by iso_code,year(case_date),month(case_date) order by iso_code) as total_cases,
sum(new_deaths) over (partition by iso_code, year(case_date),month(case_date) order by iso_code) as total_deaths

FROM covid_19_cases
where iso_code not like '%OWID%' 
)

select d.iso_code,location,continent,date,total_cases,total_deaths , 
round((total_deaths/total_cases)*100,2) as fatality_rate,
population , round((total_deaths/population)*1000000,2) as mortality_rate_per_milion 
from summary s
left join demographics d
using(iso_code);

