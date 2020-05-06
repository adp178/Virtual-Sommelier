--------------------------------------------------------
--  DDL for View CONTINENT_COUNTRY_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "CONTINENT_COUNTRY_VIEW" ("ID", "COUNTRY", "NO_OF_WINES", "CONTINENT", "WINERY_CNT", "AVG_POINTS", "AVG_PRICE") AS 
  SELECT two_letter_country_code AS ID,
  c.country_name                 AS COUNTRY,
  NVL(c_wine_cnt,0)              AS NO_OF_WINES,
  c.continent_name               AS CONTINENT,
  NVL(winery_cnt,0)              AS WINERY_CNT,
  NVL(avg_points,0)              AS AVG_POINTS,
  NVL(avg_price,0)               AS AVG_PRICE
FROM CONTINENT_COUNTRY_MAPPING c
LEFT JOIN
  (SELECT WINERY.country_name,
    SUM(wine_cnt) AS c_wine_cnt, NVL(round(SUM(winery_avg_points*wine_cnt)/SUM(wine_cnt),2),0) as avg_points,
    NVL(round(SUM(winery_avg_price*wine_cnt)/SUM(wine_cnt),2),0) as avg_price
  FROM WINERY
  LEFT JOIN
    (SELECT WINERY_NAME,
      COUNT(WINE.TITLE) AS wine_cnt, round(avg(WINE.POINTS),2) as winery_avg_points, round(avg(wine.price),2) as winery_avg_price 
    FROM WINE_WINERY_MAPPING
    LEFT JOIN WINE
    ON WINE_WINERY_MAPPING.TITLE = WINE.TITLE
    GROUP BY WINERY_NAME
    ) TEMP ON WINERY.WINERY_NAME = TEMP.WINERY_NAME
  GROUP BY WINERY.COUNTRY_NAME
  ) x ON c.country_name = x.country_name
  
  left join (select country_name, count(winery_name) winery_cnt from winery group by country_name) f on c.country_name = f.country_name

ORDER BY c.country_name
