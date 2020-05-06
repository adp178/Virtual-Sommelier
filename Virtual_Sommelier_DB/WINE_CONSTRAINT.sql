--------------------------------------------------------
--  Constraints for Table WINE
--------------------------------------------------------

  ALTER TABLE "WINE" MODIFY ("TITLE" NOT NULL ENABLE)
  ALTER TABLE "WINE" MODIFY ("VARIETY" NOT NULL ENABLE)
  ALTER TABLE "WINE" ADD CONSTRAINT "WINE_PK" PRIMARY KEY ("TITLE", "VARIETY")
  USING INDEX  ENABLE
