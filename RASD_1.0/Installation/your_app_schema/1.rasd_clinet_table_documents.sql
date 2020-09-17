
set define off
spool 1.rasd_clinet_table_documents.log

prompt
prompt Creating table DOCUMENTS
prompt ========================
prompt
create table DOCUMENTS
(
  name         VARCHAR2(256) not null,
  mime_type    VARCHAR2(128),
  doc_size     NUMBER,
  dad_charset  VARCHAR2(128),
  last_updated DATE,
  content_type VARCHAR2(128),
  blob_content BLOB
)
;


spool off
