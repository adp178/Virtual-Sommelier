--------------------------------------------------------
--  DDL for View WINERY_PROVINCE_CNT_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WINERY_PROVINCE_CNT_VIEW" ("WINERY_NAME", "PROVINCE", "COUNTRY_NAME", "P_WINE_CNT", "AVG_PRICE", "AVG_POINTS") AS 
  SELECT WINERY.WINERY_NAME,
  MAX(PROVINCE)                                      AS PROVINCE,
  MAX(COUNTRY_NAME)                                      AS COUNTRY_NAME,
  SUM(wine_cnt)                                          AS p_wine_cnt,
  NVL(ROUND(SUM(avg_price *wine_cnt)/SUM(wine_cnt),2),0) AS avg_price ,
  NVL(ROUND(SUM(avg_points*wine_cnt)/SUM(wine_cnt),2),0) AS avg_points
FROM WINERY
LEFT JOIN
  (SELECT WINERY_NAME,
    COUNT(WINE.TITLE) AS wine_cnt,
    ROUND(AVG(WINE.PRICE),2) avg_price,
    ROUND(AVG(WINE.POINTS),2) avg_points
  FROM WINE_WINERY_MAPPING
  LEFT JOIN WINE
  ON WINE_WINERY_MAPPING.TITLE = WINE.TITLE
  GROUP BY WINERY_NAME
  ) TEMP ON WINERY.WINERY_NAME = TEMP.WINERY_NAME
WHERE WINERY.WINERY_NAME        IS NOT NULL
GROUP BY WINERY.WINERY_NAME
ORDER BY WINERY.WINERY_NAME
