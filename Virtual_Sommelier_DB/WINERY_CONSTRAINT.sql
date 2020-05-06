--------------------------------------------------------
--  Constraints for Table WINERY
--------------------------------------------------------

  ALTER TABLE "WINERY" MODIFY ("WINERY_NAME" NOT NULL ENABLE)
  ALTER TABLE "WINERY" ADD CONSTRAINT "WINERY_PK" PRIMARY KEY ("WINERY_NAME")
  USING INDEX  ENABLE
