--------------------------------------------------------
--  DDL for View PROVINCE_CNT_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "PROVINCE_CNT_VIEW" ("PROVINCE", "COUNTRY_NAME", "P_WINE_CNT", "AVG_PRICE", "AVG_POINTS") AS 
  SELECT PROVINCE,
MAX(COUNTRY_NAME) AS COUNTRY_NAME,
    SUM(wine_cnt) AS p_wine_cnt,NVL(round(SUM(avg_price*wine_cnt)/SUM(wine_cnt),2),0) as avg_price ,
    NVL(round(SUM(avg_points*wine_cnt)/SUM(wine_cnt),2),0) as avg_points 
  FROM WINERY
  LEFT JOIN(
SELECT WINERY_NAME,
      COUNT(WINE.TITLE) AS wine_cnt,round(AVG(WINE.PRICE),2) avg_price, round(AVG(WINE.POINTS),2) avg_points 
    FROM WINE_WINERY_MAPPING
    LEFT JOIN WINE
    ON WINE_WINERY_MAPPING.TITLE = WINE.TITLE
    GROUP BY WINERY_NAME)
    TEMP ON WINERY.WINERY_NAME = TEMP.WINERY_NAME
    WHERE PROVINCE IS NOT NULL
  GROUP BY WINERY.PROVINCE
  ORDER BY PROVINCE
