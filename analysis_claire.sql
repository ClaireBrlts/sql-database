use wine;

select count(*) from climate;

select * from region_df ;

#Display a list of column names
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'wine'  -- replace with your DB name
  AND TABLE_NAME = 'climate';       -- replace with your table name

#what are the countries that have the most references?
select r.country, count(w.name) as num_wine_ref
from wine_df2 w
left join region_df r
on w.region = r.region
group by r.country
order by num_wine_ref desc;

#what is the region with the highest average rating?
select max(r.country) as country, w.region,
round(avg(rating),2) as avg_rating,
round(avg(price),2) as avg_price,
count(*)
from wine_df w
left join region_df r
on w.region = r.region
group by region
order by avg_rating desc;

#what is the country with the highest average rating?
select country,
round(avg(rating),2) as avg_rating,
round(avg(price),2) as avg_price,
count(*)
from wine_weather
group by country
order by avg_rating desc;

#what are the cheapest and most expensive wines?
select country, region, winery, price, rating, year, type
from wine_weather
where price = (select max(price) from wine_weather);

select country, region, winery, price, rating, year, type
from wine_weather
where price = (select min(price) from wine_weather);

#what year produced the best wine worldwide?
select distinct year
from wine_weather
order by year desc;

select year, round(avg(rating),2) as avg_rating
from wine_weather
group by year
order by avg_rating desc
limit 1;

#Which year produced the worst wine worldwide?
select year, round(avg(rating),2) as avg_rating
from wine_weather
where country = 'France'
group by year
order by avg_rating
;

select distinct country
from wine_weather;

select count(*)
from wine_df;
