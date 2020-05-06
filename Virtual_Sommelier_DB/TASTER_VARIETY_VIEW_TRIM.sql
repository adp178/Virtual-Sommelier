--------------------------------------------------------
--  DDL for View TASTER_VARIETY_VIEW_TRIM
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "TASTER_VARIETY_VIEW_TRIM" ("TASTER_NAME", "VARIETY", "WINE_CNT", "POINTS", "POINTSRANK", "TITLE") AS 
  SELECT TASTER_NAME, VARIETY, WINE_CNT, POINTS, POINTSRANK, regexp_replace(
     title,
     '(((\w+)\s){1}).*',
     '\1'
   ) AS TITLE FROM TASTER_VARIETY_VIEW
