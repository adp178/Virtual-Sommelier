--------------------------------------------------------
--  DDL for View WINERY_DETAILS_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "WINERY_DETAILS_VIEW" ("WINERY_NAME", "AVG_POINTS", "AVG_PRICE", "CNT_WINE") AS 
  select "WINERY_NAME","AVG_POINTS","AVG_PRICE","CNT_WINE" from (    
SELECT a.winery_name,
  ROUND(AVG(c.points),2) avg_points,
  ROUND(AVG(c.price),2) avg_price,
  COUNT(c.title) cnt_wine
FROM winery a
LEFT JOIN wine_winery_mapping b
ON a.winery_name = b.winery_name
LEFT JOIN wine c
ON b.title = c.title
GROUP BY a.winery_name
HAVING AVG(C.POINTS) is NOT NULL
AND AVG(C.PRICE) is NOT NULL
ORDER BY avg_price DESC

) where avg_points< 150 and  cnt_wine <100
