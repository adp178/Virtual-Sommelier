--------------------------------------------------------
--  DDL for View TASTER_VARIETY_VIEW_FULL_TITLE
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TASTER_VARIETY_VIEW_FULL_TITLE" ("TASTER_NAME", "VARIETY", "WINE_CNT", "POINTS", "POINTSRANK", "TITLE") AS 
  select x.taster_name, x.variety, x.wine_cnt,y.points,y.pointsrank,y.title as title from (
SELECT taster_name,
  variety,
  COUNT(w.title) as wine_cnt
--  max(points)
FROM wine_taster_mapping wt
LEFT JOIN wine w
ON wt.title        = w.title
WHERE taster_name IS NOT NULL
GROUP BY (taster_name, variety)
HAVING COUNT(w.title) > 40
ORDER BY taster_name,
  COUNT(w.title) DESC) x

left join 
(
select * from (
SELECT taster_name,
  variety,
  points,
  wt.title,
  RANK() over (partition by taster_name,variety order by points DESC )  AS pointsrank
  FROM wine_taster_mapping wt
LEFT JOIN wine w
ON wt.title        = w.title
WHERE taster_name IS NOT NULL
ORDER BY taster_name,variety

) where  pointsrank<2

   
  ) y on x.taster_name = y.taster_name and x.variety = y.variety
where x.taster_name in (

SELECT taster_name
FROM
  (SELECT taster_name,
    COUNT(title)
  FROM wine_taster_mapping
  WHERE taster_name IS NOT NULL
  GROUP BY taster_name
  ORDER BY COUNT(title) desc
  )
WHERE rownum <8)
