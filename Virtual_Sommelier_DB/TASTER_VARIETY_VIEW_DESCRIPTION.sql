--------------------------------------------------------
--  DDL for View TASTER_VARIETY_VIEW_DESCRIPTION
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TASTER_VARIETY_VIEW_DESCRIPTION" ("TITLE", "FULLNAME", "POINTS", "TASTER_NAME", "DESCRIPTION", "VARIETY") AS 
  SELECT regexp_replace(
     w.title,
     '(((\w+)\s){1}).*',
     '\1'
   ) AS TITLE,w.title as fullname, t.points ,t.taster_name, w.description description,w.variety
FROM taster_variety_view t
LEFT JOIN wine w
ON t.variety = w.variety
AND w.title = T.TITLE
AND t.points        = w.points
