----- drop newly created tables & constraints

DROP TABLE "REG"."LOC_HIERARCHY_LIST";
DROP TABLE "REG"."PERMITTED_LOCAL_CONFIG";
DROP TABLE "REG"."LOCAL_PREFERENCES";
DROP TABLE "REG"."PROCESS_SPEC";
DROP TABLE "REG"."FILE_SIGNATURE";

----- Changes in key-manager related tables

ALTER TABLE "REG"."CA_CERT_STORE" DROP CONSTRAINT "UK_CERT_THUMBPRINT";
ALTER TABLE "REG"."KEY_ALIAS" DROP CONSTRAINT "UK_UNI_IDENT";
ALTER TABLE "REG"."KEY_ALIAS" DROP COLUMN "UNI_IDENT";
ALTER TABLE "REG"."KEY_ALIAS" DROP COLUMN "CERT_THUMBPRINT";
ALTER TABLE "REG"."KEY_POLICY_DEF" DROP COLUMN "PRE_EXPIRE_DAYS";
ALTER TABLE "REG"."KEY_POLICY_DEF" DROP COLUMN "ACCESS_ALLOWED";
DELETE FROM "REG"."KEY_POLICY_DEF" WHERE APP_ID='BASE';

------

ALTER TABLE "REG"."REGISTRATION" DROP CONSTRAINT "PK_REG_ID";
ALTER TABLE "REG"."REGISTRATION" DROP COLUMN "APP_ID";
ALTER TABLE "REG"."REGISTRATION" DROP COLUMN "PACKET_ID";
ALTER TABLE "REG"."REGISTRATION" DROP COLUMN "ADDITIONAL_INFO_REQ_ID";
ALTER TABLE "REG"."REGISTRATION" DROP COLUMN "ACK_SIGNATURE";
ALTER TABLE "REG"."REGISTRATION" DROP COLUMN "HAS_BWORDS";
ALTER TABLE "REG"."REGISTRATION" ADD CONSTRAINT "PK_REG_ID" PRIMARY KEY ("ID");
ALTER TABLE "REG"."REGISTRATION_TRANSACTION" DROP COLUMN "APP_ID";

ALTER TABLE "REG"."USER_DETAIL" DROP COLUMN "REG_CNTR_ID";
ALTER TABLE "REG"."MACHINE_MASTER" DROP COLUMN "REG_CNTR_ID";


----- roll back dropped tables

CREATE TABLE "REG"."AUDIT_LOG_CONTROL" ("REG_ID" VARCHAR(39) NOT NULL, "AUDIT_LOG_FROM_DTIMES" TIMESTAMP NOT NULL, "AUDIT_LOG_TO_DTIMES" TIMESTAMP NOT NULL, "AUDIT_LOG_SYNC_DTIMES" TIMESTAMP, "AUDIT_LOG_PURGE_DTIMES" TIMESTAMP, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."AUDIT_LOG_CONTROL" ADD CONSTRAINT "PK_ALGC" PRIMARY KEY ("REG_ID");
ALTER TABLE "REG"."AUDIT_LOG_CONTROL" ADD CONSTRAINT "FK_ALGC_REG" FOREIGN KEY ("REG_ID") REFERENCES "REG"."REGISTRATION" ("ID") ON DELETE NO ACTION ON UPDATE NO ACTION;

CREATE TABLE "REG"."DEVICE_TYPE" ("CODE" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "DESCR" VARCHAR(128), "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."DEVICE_TYPE" ADD CONSTRAINT "PK_DTYP_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

CREATE TABLE "REG"."REG_CENTER_MACHINE_DEVICE" ("REGCNTR_ID" VARCHAR(10) NOT NULL, "MACHINE_ID" VARCHAR(10) NOT NULL, "DEVICE_ID" VARCHAR(36) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."REG_CENTER_MACHINE_DEVICE" ADD CONSTRAINT "PK_CNTRMDEV_CNTR_ID" PRIMARY KEY ("REGCNTR_ID", "MACHINE_ID", "DEVICE_ID");

CREATE TABLE "REG"."MOSIP_DEVICE_SERVICE" ("ID" VARCHAR(36) NOT NULL, "SW_BINARY_HASH" BLOB(2147483647) NOT NULL, "SW_VERSION" VARCHAR(64) NOT NULL, "DPROVIDER_ID" VARCHAR(36) NOT NULL, "DTYPE_CODE" VARCHAR(36) NOT NULL, "DSTYPE_CODE" VARCHAR(36) NOT NULL, "MAKE" VARCHAR(36) NOT NULL, "MODEL" VARCHAR(36) NOT NULL, "SW_CR_DTIMES" TIMESTAMP, "SW_EXPIRY_DTIMES" TIMESTAMP, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(256) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(256), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."MOSIP_DEVICE_SERVICE" ADD CONSTRAINT "PK_MDS_ID" PRIMARY KEY ("ID");
ALTER TABLE "REG"."MOSIP_DEVICE_SERVICE" ADD CONSTRAINT "UK_MDS" UNIQUE ("SW_VERSION", "DPROVIDER_ID", "DTYPE_CODE", "DSTYPE_CODE", "MAKE", "MODEL");

CREATE TABLE "REG"."REG_CENTER_MACHINE" ("REGCNTR_ID" VARCHAR(10) NOT NULL, "MACHINE_ID" VARCHAR(10) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."REG_CENTER_MACHINE" ADD CONSTRAINT "PK_CNTRMAC_USR_ID" PRIMARY KEY ("REGCNTR_ID", "MACHINE_ID");

CREATE TABLE "REG"."GENDER" ("CODE" CHAR(16) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."GENDER" ADD CONSTRAINT "PK_GNDR_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

CREATE TABLE "REG"."FOUNDATIONAL_TRUST_PROVIDER" ("ID" VARCHAR(36) NOT NULL, "NAME" VARCHAR(128) NOT NULL, "ADDRESS" VARCHAR(512), "EMAIL" VARCHAR(512), "CONTACT_NUMBER" VARCHAR(16), "CERTIFICATE_ALIAS" VARCHAR(36), "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(256) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(256), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."FOUNDATIONAL_TRUST_PROVIDER" ADD CONSTRAINT "PK_FTPRD_ID" PRIMARY KEY ("ID");

CREATE TABLE "REG"."INDIVIDUAL_TYPE" ("CODE" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."INDIVIDUAL_TYPE" ADD CONSTRAINT "PK_INDVTYP_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

CREATE TABLE "REG"."DEVICE_SPEC" ("ID" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "BRAND" VARCHAR(32) NOT NULL, "MODEL" VARCHAR(16) NOT NULL, "DTYP_CODE" VARCHAR(36) NOT NULL, "MIN_DRIVER_VER" VARCHAR(16) NOT NULL, "DESCR" VARCHAR(256), "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."DEVICE_SPEC" ADD CONSTRAINT "PK_DSPEC_CODE" PRIMARY KEY ("ID", "LANG_CODE");

CREATE TABLE "REG"."DEVICE_MASTER" ("ID" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "MAC_ADDRESS" VARCHAR(64) NOT NULL, "SERIAL_NUM" VARCHAR(64) NOT NULL, "IP_ADDRESS" VARCHAR(17), "VALIDITY_END_DTIMES" TIMESTAMP, "DSPEC_ID" VARCHAR(36) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."DEVICE_MASTER" ADD CONSTRAINT "PK_DEVICEM_ID" PRIMARY KEY ("ID", "LANG_CODE");

CREATE TABLE "REG"."REG_DEVICE_SUB_TYPE" ("CODE" VARCHAR(36) NOT NULL, "DTYP_CODE" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "DESCR" VARCHAR(512), "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(256) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(256), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."REG_DEVICE_SUB_TYPE" ADD CONSTRAINT "PK_RDSTYP_CODE" PRIMARY KEY ("CODE");
ALTER TABLE "REG"."REG_DEVICE_SUB_TYPE" ADD CONSTRAINT "UK_RDSTYP" UNIQUE ("DTYP_CODE", "NAME");

CREATE TABLE "REG"."REG_CENTER_DEVICE" ("REGCNTR_ID" VARCHAR(10) NOT NULL, "DEVICE_ID" VARCHAR(36) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."REG_CENTER_DEVICE" ADD CONSTRAINT "PK_CNTRDEV_ID" PRIMARY KEY ("REGCNTR_ID", "DEVICE_ID");

CREATE TABLE "REG"."TITLE" ("CODE" VARCHAR(16) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "DESCR" VARCHAR(128), "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."TITLE" ADD CONSTRAINT "PK_TTL_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

CREATE TABLE "REG"."APP_DETAIL" ("ID" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "DESCR" VARCHAR(256), "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."APP_DETAIL" ADD CONSTRAINT "PK_APPDTL_ID" PRIMARY KEY ("ID", "LANG_CODE");
CREATE UNIQUE INDEX "REG"."IDX_APPDTL_NAME" ON "REG"."APP_DETAIL" ("NAME");

CREATE TABLE "REG"."REG_DEVICE_TYPE" ("CODE" VARCHAR(36) NOT NULL, "NAME" VARCHAR(64) NOT NULL, "DESCR" VARCHAR(512), "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(256) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(256), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."REG_DEVICE_TYPE" ADD CONSTRAINT "PK_RDTYP_CODE" PRIMARY KEY ("CODE");

CREATE TABLE "REG"."DEVICE_PROVIDER" ("ID" VARCHAR(36) NOT NULL, "VENDOR_NAME" VARCHAR(128) NOT NULL, "ADDRESS" VARCHAR(512), "EMAIL" VARCHAR(512), "CONTACT_NUMBER" VARCHAR(16), "CERTIFICATE_ALIAS" VARCHAR(36), "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(256) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(256), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."DEVICE_PROVIDER" ADD CONSTRAINT "PK_DEVPRD_ID" PRIMARY KEY ("ID");

CREATE TABLE "REG"."TEMPLATE_TYPE" ("CODE" VARCHAR(36) NOT NULL, "DESCR" VARCHAR(256) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."TEMPLATE_TYPE" ADD CONSTRAINT "PK_TMPLTYP_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

CREATE TABLE "REG"."TEMPLATE_FILE_FORMAT" ("CODE" VARCHAR(36) NOT NULL, "DESCR" VARCHAR(256) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."TEMPLATE_FILE_FORMAT" ADD CONSTRAINT "PK_TFFMT_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

CREATE TABLE "REG"."REG_CENTER_USER" ("REGCNTR_ID" VARCHAR(10) NOT NULL, "USR_ID" VARCHAR(36) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."REG_CENTER_USER" ADD CONSTRAINT "PK_CNTRUSR_USR_ID" PRIMARY KEY ("REGCNTR_ID", "USR_ID");

CREATE TABLE "REG"."VALID_DOCUMENT" ("DOCTYP_CODE" VARCHAR(36) NOT NULL, "DOCCAT_CODE" VARCHAR(36) NOT NULL, "LANG_CODE" VARCHAR(3) NOT NULL, "IS_ACTIVE" BOOLEAN NOT NULL, "CR_BY" VARCHAR(32) NOT NULL, "CR_DTIMES" TIMESTAMP NOT NULL, "UPD_BY" VARCHAR(32), "UPD_DTIMES" TIMESTAMP, "IS_DELETED" BOOLEAN, "DEL_DTIMES" TIMESTAMP);
ALTER TABLE "REG"."VALID_DOCUMENT" ADD CONSTRAINT "PK_VALDOC_CODE" PRIMARY KEY ("DOCTYP_CODE", "DOCCAT_CODE");

ALTER TABLE "REG"."MACHINE_SPEC" ALTER COLUMN "LANG_CODE" NOT NULL;
ALTER TABLE "REG"."MACHINE_SPEC" DROP CONSTRAINT "PK_MSPEC_CODE";
ALTER TABLE "REG"."MACHINE_SPEC" ADD CONSTRAINT "PK_MSPEC_CODE" PRIMARY KEY ("ID", "LANG_CODE");

ALTER TABLE "REG"."MACHINE_TYPE" ALTER COLUMN "LANG_CODE" NOT NULL;
ALTER TABLE "REG"."MACHINE_TYPE" DROP CONSTRAINT "PK_MTYP_CODE";
ALTER TABLE "REG"."MACHINE_TYPE" ADD CONSTRAINT "PK_MTYP_CODE" PRIMARY KEY ("CODE", "LANG_CODE");

ALTER TABLE "REG"."MACHINE_MASTER" ALTER COLUMN "LANG_CODE" NOT NULL;
ALTER TABLE "REG"."MACHINE_MASTER" DROP CONSTRAINT "PK_MACHM_ID";
ALTER TABLE "REG"."MACHINE_MASTER" ADD CONSTRAINT "PK_MACHM_ID" PRIMARY KEY ("ID", "LANG_CODE");

-----
delete from "REG"."GLOBAL_PARAM" where code='mosip.kernel.vid.restricted-numbers';
delete from "REG"."GLOBAL_PARAM" where code='mosip.kernel.vid.not-start-with';
delete from "REG"."GLOBAL_PARAM" where code='mosip.kernel.vid.length.repeating-limit';
delete from "REG"."GLOBAL_PARAM" where code='mosip.kernel.vid.length.repeating-block-limit';
delete from "REG"."GLOBAL_PARAM" where code='mosip.kernel.vid.length.sequence-limit';
delete from "REG"."GLOBAL_PARAM" where code='mosip.kernel.vid.length';
delete from "REG"."GLOBAL_PARAM" where code='mosip.registration.audit_timestamp';