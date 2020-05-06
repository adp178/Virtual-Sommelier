--------------------------------------------------------
--  DDL for View DRILL_DOWN_VIEW
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "DRILL_DOWN_VIEW" ("COUNTRY_NAME", "PROVINCE", "P_WINE_CNT", "P_AVG_PRICE", "P_AVG_POINTS", "VARIETY", "WINE_LEVEL", "V_AVG_POINTS", "V_AVG_PRICE", "V_WINE_CNT", "V_TITLE") AS 
  WITH DUMMY AS (
select Y.PROVINCE, Y.VARIETY, ROUND( Y.WINE_LEVEL,2) AS WINE_LEVEL, X.TITLE,Y.AVG_POINTS, Y.AVG_PRICE,Y.WINE_CNT  from 

(select c.province,a.variety,
    (a.points/a.price) as  wine_level, a.title
FROM wine a
  LEFT JOIN Wine_Winery_Mapping b
  ON a.title = b.title
  LEFT JOIN winery c
  ON b.winery_name        = c.winery_name
  WHERE a.points/a.price IS NOT NULL
  AND c.province         IS NOT NULL
  AND b.winery_name      IS NOT NULL
  
) x inner join 
(SELECT province,
    a.variety,
    count(a.title) wine_cnt,
    avg(a.points) AS AVG_POINTS,
    avg(a.price) AS AVG_PRICE,
    max(a.points/a.price) as wine_level
    
  FROM wine a
  LEFT JOIN Wine_Winery_Mapping b
  ON a.title = b.title
  LEFT JOIN winery c
  ON b.winery_name        = c.winery_name
  WHERE a.points/a.price IS NOT NULL
  AND c.province         IS NOT NULL
  AND b.winery_name      IS NOT NULL
  group by province,variety
  ORDER BY province,
    count(a.title) DESC) y on x.province = y.province and x.variety = y.variety and x.wine_level = y.wine_level
    
)
SELECT P.COUNTRY_NAME,p.province,p_wine_cnt, P.avg_price AS P_AVG_PRICE, P.avg_points AS P_AVG_POINTS, variety,
D.WINE_LEVEL,ROUND(D.AVG_POINTS,2) AS V_AVG_POINTS, ROUND(D.AVG_PRICE,2) AS V_AVG_PRICE, WINE_CNT AS V_WINE_CNT, D.TITLE AS V_TITLE
FROM PROVINCE_CNT_VIEW p
RIGHT JOIN dummy d
ON p.province = d.province
ORDER BY p_wine_cnt desc, v_wine_cnt desc
