drop table weekcountenf;
drop table redirect;
drop table page;

CREATE TABLE weekcountenf (
	"lang"  string,
	"page"  string,
	"year"  INT,
	"week"  INT,
	"count" BIGINT
);

CREATE TABLE "redirect" (
  "rd_from" int NOT NULL DEFAULT '0',
  "rd_namespace" int NOT NULL DEFAULT '0',
  "rd_title" string NOT NULL DEFAULT '',
  "rd_interwiki" string DEFAULT NULL,
  "rd_fragment" string DEFAULT NULL
 );

CREATE TABLE "page" (
  "page_id" int NOT NULL AUTO_INCREMENT,
  "page_namespace" int NOT NULL DEFAULT '0',
  "page_title" string NOT NULL DEFAULT '',
  "page_restrictions" string NOT NULL,
  "page_counter" int  NOT NULL DEFAULT '0',
  "page_is_redirect" int NOT NULL DEFAULT '0',
  "page_is_new" int NOT NULL DEFAULT '0',
  "page_random" double  NOT NULL DEFAULT '0',
  "page_touched" string NOT NULL DEFAULT '',
  "page_links_updated" string DEFAULT NULL,
  "page_latest" int NOT NULL DEFAULT '0',
  "page_len" int NOT NULL DEFAULT '0',
  "page_content_model" string DEFAULT NULL
);
