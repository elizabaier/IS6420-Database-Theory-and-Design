-- create daily_aqi_2023 table
drop table if exists daily_aqi_2023;

create table daily_aqi_2023 (
  state_name varchar(100),
  county_name varchar(100),
  state_code char(2),
  county_code char(3),
  date date,
  aqi integer,
  category varchar(100),
  defining_parameter varchar(25),
  defining_site varchar(20),
  number_of_sites_reporting integer
);

-- create daily_aqi_2013 table
drop table if exists daily_aqi_2013;

create table daily_aqi_2013 (
  state_name varchar(100),
  county_name varchar(100),
  state_code char(2),
  county_code char(3),
  date date,
  aqi integer,
  category varchar(100),
  defining_parameter varchar(25),
  defining_site varchar(20),
  number_of_sites_reporting integer
);

-- create daily_aqi_2003 table
drop table if exists daily_aqi_2003;

create table daily_aqi_2003 (
  state_name varchar(100),
  county_name varchar(100),
  state_code char(2),
  county_code char(3),
  date date,
  aqi integer,
  category varchar(100),
  defining_parameter varchar(25),
  defining_site varchar(20),
  number_of_sites_reporting integer
);


--create season function
create or replace function get_season(date_input date)
returns text as $$
begin
    return case 
        when extract(month from date_input) in (12, 1, 2) then 'Winter'
        when extract(month from date_input) in (3, 4, 5) then 'Spring'
        when extract(month from date_input) in (6, 7, 8) then 'Summer'
        when extract(month from date_input) in (9, 10, 11) then 'Fall'
    end;
end;
$$ language plpgsql;

-- test season function
select 
    date,
    get_season(date) as season
from 
    daily_aqi_2023;

--avg aqi in 2023 by season
select 
	get_season(date) as season,
	round(avg(aqi), 2) as avg_aqi_2023
from 
	daily_aqi_2023
group by 
	season;

-- avg aqi in 2013 by season
select 
	get_season(date) as season,
	round(avg(aqi), 2) as avg_aqi_2013
from
	daily_aqi_2013
group by 
	season;

-- avg aqi in 2003 by season
select 
	get_season(date) as season,
	round(avg(aqi), 2) as avg_aqi_2003
from
	daily_aqi_2003
group by 	
	season;

-- combine all queries with union all
--avg aqi in 2023 by season
select 
	get_season(date) as season,
	round(avg(aqi), 2) as avg_aqi,
	'2023' as year
from 
	daily_aqi_2023
group by 
	season

union all
-- avg aqi in 2013 by season
select 
	get_season(date) as season,
	round(avg(aqi), 2) as avg_aqi,
	'2013' as year
from
	daily_aqi_2013
group by 
	season

union all
-- avg aqi in 2003 by season
select 
	get_season(date) as season,
	round(avg(aqi), 2) as avg_aqi,
	'2003' as year
from
	daily_aqi_2003
group by 
	season
order by 
	year, 
	season;

-- top 10 locations with worst (highest) aqi in each year
with ranked_aqi as 
    (select 
        state_name as state,
        county_name as county,
        aqi,
        '2023' as year,
        row_number() over (partition by '2023' order by aqi desc) as rank
    from 
        daily_aqi_2023

    union all 

    select 
        state_name as state,
        county_name as county,
        aqi,
        '2013' as year,
        row_number() over (partition by '2013' order by aqi desc) as rank
    from 
        daily_aqi_2013

    union all

    select 
        state_name as state,
        county_name as county,
        aqi,
        '2003' as year,
		row_number() over (partition by '2003' order by aqi desc) as rank
    from 
        daily_aqi_2003)
        
select 
	state, 
	county, 
	aqi, 
	year
from 
	ranked_aqi
where 
	rank <= 10
order by 
	year asc, 
	aqi desc;
	
-- top 10 locations with greatest improvement of average AQI from 2003 to 2023
with aqi_summary as     
		(select
        yr2003.state_name,
        yr2003.county_name,
        yr2003.aqi as aqi_2003,
        yr2023.aqi as aqi_2023
    from
        daily_aqi_2003 yr2003
    join
        daily_aqi_2023 yr2023
    on
        yr2003.state_name = yr2023.state_name
        and yr2003.county_name = yr2023.county_name
    group by
    	yr2003.state_name,
    	yr2003.county_name,
    	yr2003.aqi,
    	yr2023.aqi),
aqi_change as
    (select
        state_name,
        county_name,
        aqi_2003,
        aqi_2023,
        (aqi_2003 - aqi_2023) AS aqi_change
    from
        aqi_summary)
select
    state_name as state,
    county_name as county,
    aqi_2003,
    aqi_2023,
    aqi_change
from
    aqi_change
where
    aqi_change > 0
order by
    aqi_change desc
limit 10;

-- top 10 locations with worst decline (increase) in average AQI from 2003 to 2023
with aqi_summary as
    (select
        yr2003.state_name,
        yr2003.county_name,
        round(avg(yr2003.aqi), 2) AS avg_aqi_2003,
        round(avg(yr2023.aqi), 2) AS avg_aqi_2023
    from
        daily_aqi_2003 yr2003
    join
        daily_aqi_2023 yr2023
    on
        yr2003.state_name = yr2023.state_name
        and yr2003.county_name = yr2023.county_name
    group by
    	yr2003.state_name,
    	yr2003.county_name),
aqi_change as
    (select
        state_name,
        county_name,
        avg_aqi_2003,
        avg_aqi_2023,
        (avg_aqi_2023 - avg_aqi_2003) as aqi_change
    from
        aqi_summary)
select
    state_name as state,
    county_name as county,
    avg_aqi_2003,
    avg_aqi_2023,
    aqi_change
from
    aqi_change
where
    aqi_change > 0 
order by
    aqi_change desc
limit 10;

-- In Utah counties, how many days of "Unhealthy" air did we have in each year?  Is it improving?  
select 
	count(date) as days_of_unhealthy_air,
	'2003' as year
from 
	daily_aqi_2003 
where 
	aqi >= 100 and
	state_name = 'Utah'

union all

select
	count(date) as days_of_unhealthy_air,
	'2013' as year
from
	daily_aqi_2013
where 
	aqi >= 100 and 
	state_name = 'Utah'

union all

select
	count(date) as days_of_unhealthy_air,
	'2023' as year
from
	daily_aqi_2023
where 
	aqi >= 100 and 
	state_name = 'Utah';

-- In Salt Lake County, which months have the most "Unhealthy" days?  Has that changed in 20 years?
select 
	extract(month from date) as month,
	coalesce(count(date), 0) as unhealthy_days
from daily_aqi_2023
where 
	aqi >= 100 and 
	county_name = 'Salt Lake'
group by 
	extract(month from date)
order by 	
	unhealthy_days desc;

WITH all_months AS (
    SELECT generate_series(1, 12) AS month -- This generates numbers 1 through 12 (for each month)
)
SELECT 
    m.month,
    COALESCE(COUNT(d.date), 0) AS unhealthy_days
FROM 
    all_months m
LEFT JOIN 
    daily_aqi_2023 d
    ON EXTRACT(MONTH FROM d.date) = m.month
    AND d.aqi >= 100
    AND d.county_name = 'Salt Lake'
GROUP BY 
    m.month
ORDER BY 
    unhealthy_days desc;
 
   
   
   
select 
	extract(month from date) as month,
	coalesce(count(date), 0) as unhealthy_days
from daily_aqi_2003
where 
	aqi >= 100 and 
	county_name = 'Salt Lake'
group by 
	extract(month from date)
order by 	
	unhealthy_days desc;

WITH all_months AS (
    SELECT generate_series(1, 12) AS month -- This generates numbers 1 through 12 (for each month)
)
SELECT 
    m.month,
    COALESCE(COUNT(d.date), 0) AS unhealthy_days
FROM 
    all_months m
LEFT JOIN 
    daily_aqi_2003 d
    ON EXTRACT(MONTH FROM d.date) = m.month
    AND d.aqi >= 100
    AND d.county_name = 'Salt Lake'
GROUP BY 
    m.month
ORDER BY 
    unhealthy_days desc;
	