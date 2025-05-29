-- checking to see if regions are now matching across wine and region tables --

SELECT 
  COUNT(*) AS unmatched_regions
FROM wine w
LEFT JOIN region r ON w.region = r.region
WHERE r.region IS NULL;

-- country with most wines reviewed --
SELECT 
    r.country, 
    r.continent,
    COUNT(w.name) AS num_wine_ref
FROM 
    wine w
LEFT JOIN 
    region r ON w.region = r.region
GROUP BY 
    r.country, r.continent
ORDER BY 
    num_wine_ref DESC;
    
--  What are the countries with the highest ratings? -- 
SELECT
    r.country,
    ROUND(AVG(w.rating), 2) AS avg_rating,
    COUNT(w.name) AS num_wines
FROM
    wine w
    JOIN region r ON w.region = r.region
WHERE
    w.rating IS NOT NULL
GROUP BY
    r.country
HAVING
    COUNT(w.name) > 100  
ORDER BY
    avg_rating DESC;


-- worst value for money wines --

SELECT
    w.name,
    w.region,
    r.country,
    w.year,
    w.type,
    w.rating,
    w.price,
    ROUND(w.price / NULLIF(w.rating, 0), 1) AS price_to_rating_ratio
FROM
    wine w
JOIN
    region r ON w.region = r.region
WHERE
    w.price IS NOT NULL
    AND w.rating IS NOT NULL
ORDER BY
    price_to_rating_ratio DESC
LIMIT 10;

-- best value for money wines --
SELECT
    w.name,
    w.region,
    r.country,
    w.year,
    w.rating,
    w.type,
    w.price,
    ROUND(w.price / NULLIF(w.rating, 0), 2) AS price_to_rating_ratio
FROM
    wine w
JOIN
    region r ON w.region = r.region
WHERE
    w.price IS NOT NULL
    AND w.rating IS NOT NULL
ORDER BY
    price_to_rating_ratio ASC;

-- price to rating ratio per country -- 

SELECT 
    r.country,
    ROUND(AVG(w.price / NULLIF(w.rating, 0)), 2) AS avg_price_to_rating_ratio,
    ROUND(AVG(w.price), 2) AS avg_price,
    ROUND(AVG(w.rating), 2) AS avg_rating,
    COUNT(*) AS num_wines
FROM 
    wine w
JOIN 
    region r ON w.region = r.region
WHERE 
    w.price IS NOT NULL
    AND w.rating IS NOT NULL
GROUP BY 
    r.country
HAVING 
    COUNT(*) > 1000
ORDER BY 
    avg_price_to_rating_ratio DESC;


-- region with most wines reviewed -- 
SELECT
    r.region,
    COUNT(DISTINCT w.name) AS num_wines
FROM
    wine w
    JOIN region r ON w.region = r.region
GROUP BY
    r.region
ORDER BY
    num_wines DESC;
    
    
-- highest rated wines in italy -- 
WITH region_years AS (
    SELECT 
        w.year,
        w.region,
        AVG(w.rating) AS avg_rating,
        COUNT(*) AS num_wines
    FROM 
        wine w
    JOIN 
        region r ON w.region = r.region
    WHERE 
        r.country = 'Italy'
    GROUP BY 
        w.year, w.region
    HAVING 
        AVG(w.rating) > 4 AND
        COUNT(*) >= 10
),
ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY region ORDER BY avg_rating DESC) AS rn
    FROM region_years
)
SELECT 
    year, region, avg_rating, num_wines
FROM 
    ranked
WHERE 
    rn = 1
ORDER BY 
    avg_rating DESC;

-- check avg weather for best region - barolo -- 
SELECT 
    region,
    ROUND(AVG(tavg), 2) AS avg_temp_2011,
    ROUND(AVG(prcp), 2) AS avg_precipitation_2011,
    ROUND(AVG(tsun), 2) AS avg_sunshine_2011
FROM 
    climate
WHERE 
    LOWER(region) LIKE '%barolo%'
    AND year = 2011
GROUP BY 
    region;
