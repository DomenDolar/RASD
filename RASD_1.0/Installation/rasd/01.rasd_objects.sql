set define off
SET serveroutput ON
spool 01.rasd_objects.log

prompt
prompt Creating table RASD_ATTRIBUTES
prompt ==============================
prompt
create table RASD_ATTRIBUTES
(
  formid    NUMBER,
  elementid NUMBER not null,
  orderby   NUMBER not null,
  attribute VARCHAR2(100 BYTE),
  type      VARCHAR2(1 BYTE) not null,
  text      VARCHAR2(4000 BYTE),
  name      VARCHAR2(100 BYTE),
  value     VARCHAR2(4000 BYTE),
  valuecode VARCHAR2(4000 BYTE),
  forloop   VARCHAR2(100 BYTE),
  endloop   VARCHAR2(100 BYTE),
  source    VARCHAR2(1 BYTE),
  hiddenyn  VARCHAR2(1 BYTE),
  valueid   NUMBER,
  textid    NUMBER,
  textcode  VARCHAR2(4000 BYTE),
  rlobid    VARCHAR2(30),
  rform     VARCHAR2(30),
  rid       VARCHAR2(100)
)
;
comment on table RASD_ATTRIBUTES
  is 'Texts, attributes and code of elements';
comment on column RASD_ATTRIBUTES.attribute
  is 'Type (S,A,V,E)||''_''||name: S_, A_NAME, V_, E_. S,V,E can be jut once for element.';
comment on column RASD_ATTRIBUTES.type
  is 'S-Start, A-Attribut, V-Value, E-End.';
comment on column RASD_ATTRIBUTES.text
  is 'Text before tagom or attribut.';
comment on column RASD_ATTRIBUTES.name
  is 'Name of attribute or tag with no ">" or "-->".';
comment on column RASD_ATTRIBUTES.value
  is 'Value or end of tag ">" or "-->".';
comment on column RASD_ATTRIBUTES.valuecode
  is 'Value for creating code package.';
comment on column RASD_ATTRIBUTES.source
  is 'G or null - generated, R - referenced (property is set from ref. element, attribute), V - value entered, changed (changes in rasd_forms, rasd_areas, rasd_fields,... are not transmitted into rasd_elements, rasd_attributi).';
comment on column RASD_ATTRIBUTES.hiddenyn
  is 'Y-hidden, N,null-shown';
create index RASD_ATTRIBUTES_INX on RASD_ATTRIBUTES (FORMID, ELEMENTID, ATTRIBUTE);
create index RASD_ATTRIBUTES_INX2 on RASD_ATTRIBUTES (FORMID, TYPE);

prompt
prompt Creating table RASD_ATTRIBUTES_TEMPLATE
prompt =======================================
prompt
create table RASD_ATTRIBUTES_TEMPLATE
(
  coreid      NUMBER,
  element     VARCHAR2(100 BYTE),
  attribute   VARCHAR2(100 BYTE),
  type        VARCHAR2(1 BYTE) not null,
  orderby     NUMBER not null,
  text        VARCHAR2(2000 BYTE),
  textid      NUMBER,
  name        VARCHAR2(100 BYTE),
  value       VARCHAR2(2000 BYTE),
  valueid     NUMBER,
  hiddenyn    VARCHAR2(1 BYTE),
  source      VARCHAR2(1 BYTE),
  elementtype VARCHAR2(1 BYTE)
)
;
comment on column RASD_ATTRIBUTES_TEMPLATE.type
  is 'S-Start, A-Attribute, V-Value, E-End, C-Closes Attributes of Start tag.';
comment on column RASD_ATTRIBUTES_TEMPLATE.elementtype
  is 'null-common, F-Form, B-Block, D-fielD, L-Label';
alter table RASD_ATTRIBUTES_TEMPLATE
  add constraint RASD_CHECK_ATTRIBUT
  check (ATTRIBUTE=upper(type)||'_'||decode(type,'A',upper(name),''));
alter table RASD_ATTRIBUTES_TEMPLATE
  add constraint RASD_CHECK_TYPE
  check (type in ('S','A','V','E','C'));

prompt
prompt Creating table RASD_ATTRIBUTES_TEMPORARY
prompt ========================================
prompt
create table RASD_ATTRIBUTES_TEMPORARY
(
  formid    NUMBER,
  elementid NUMBER not null,
  orderby   NUMBER not null,
  attribute VARCHAR2(100 BYTE),
  type      VARCHAR2(1 BYTE) not null,
  text      VARCHAR2(2000 BYTE),
  textid    NUMBER,
  name      VARCHAR2(100 BYTE),
  value     VARCHAR2(4000 BYTE),
  valueid   NUMBER,
  hiddenyn  VARCHAR2(1 BYTE),
  source    VARCHAR2(1 BYTE)
)
;
comment on table RASD_ATTRIBUTES_TEMPORARY
  is 'Teksti in atributi in programska koda elementov';
comment on column RASD_ATTRIBUTES_TEMPORARY.attribute
  is '(S,A,V,E)||''''_''''|| name: S_, A_NAME, V_, E_. S,V,E only onced for element';
comment on column RASD_ATTRIBUTES_TEMPORARY.type
  is 'S-Start, A-Attribut, V-Value, E-End';
create index RASD_ATTRIBUTES_TEMPORARY_IX1 on RASD_ATTRIBUTES_TEMPORARY (FORMID, ELEMENTID, ATTRIBUTE);
alter table RASD_ATTRIBUTES_TEMPORARY
  add constraint RASD_ATTRIBUTES_TEMPORARY_UC unique (FORMID, ELEMENTID, TYPE, NAME)
  disable
  novalidate;

prompt
prompt Creating table RASD_BLOCKS
prompt ==========================
prompt
create table RASD_BLOCKS
(
  formid    NUMBER not null,
  blockid   VARCHAR2(30 BYTE) not null,
  sqltable  VARCHAR2(30 BYTE),
  numrows   NUMBER default 1 not null,
  emptyrows NUMBER,
  dbblockyn VARCHAR2(1 BYTE),
  rowidyn   VARCHAR2(1 BYTE),
  pagingyn  VARCHAR2(1 BYTE),
  clearyn   VARCHAR2(1 BYTE),
  sqltext   VARCHAR2(4000 BYTE),
  label     VARCHAR2(100 BYTE),
  source    VARCHAR2(1 BYTE),
  hiddenyn  VARCHAR2(1 BYTE),
  rlobid    VARCHAR2(30 BYTE),
  rform     VARCHAR2(30 BYTE),
  rblockid  VARCHAR2(30 BYTE)
)
;
comment on column RASD_BLOCKS.blockid
  is 'Name of block; Name of label = blockid + _labName; Label element is blockid + _lab;';
comment on column RASD_BLOCKS.sqltable
  is 'updateing or fi SQLTEXT has data.';
comment on column RASD_BLOCKS.dbblockyn
  is 'triggers on select';
comment on column RASD_BLOCKS.rowidyn
  is 'triggers on commit';
comment on column RASD_BLOCKS.pagingyn
  is 'paging is shown (back, forward)';
comment on column RASD_BLOCKS.clearyn
  is 'triggers on clear';
comment on column RASD_BLOCKS.sqltext
  is 'starts with Select, From or triggers on select.';
comment on column RASD_BLOCKS.source
  is 'r-in usage, R - referenced, V - Value edited, changed.';
comment on column RASD_BLOCKS.hiddenyn
  is 'Y-hidden, N,null-shown';
alter table RASD_BLOCKS
  add constraint RASD_BLOCKS_PK primary key (FORMID, BLOCKID);

prompt
prompt Creating table RASD_ELEMENTS
prompt ============================
prompt
create table RASD_ELEMENTS
(
  formid          NUMBER not null,
  elementid       NUMBER not null,
  pelementid      NUMBER not null,
  orderby         NUMBER not null,
  element         VARCHAR2(100 BYTE),
  type            VARCHAR2(1 BYTE),
  id              VARCHAR2(100 BYTE),
  nameid          VARCHAR2(100 BYTE),
  endtagelementid NUMBER,
  source          VARCHAR2(1 BYTE),
  hiddenyn        VARCHAR2(1 BYTE),
  rlobid          VARCHAR2(30 BYTE),
  rform           VARCHAR2(30 BYTE),
  rid             VARCHAR2(100 BYTE),
  includevis      VARCHAR2(30 BYTE)
)
;
comment on column RASD_ELEMENTS.elementid
  is 'Connects only to attributes.';
comment on column RASD_ELEMENTS.pelementid
  is 'Id of parent elementa.';
comment on column RASD_ELEMENTS.element
  is 'Element: INPUT_TEXT, SELECT_,...';
comment on column RASD_ELEMENTS.type
  is 'F-Form, B-Block, E-FielD, S-Site';
comment on column RASD_ELEMENTS.id
  is 'Attribute ID - NAME, if ID not exists or HTML,HEAD,TITLE, BODY: reference: idelement = id ref. element';
comment on column RASD_ELEMENTS.nameid
  is 'Attribute NAME (for tag FORM is formid, other fieldid), attribute BLOCKID for blockid';
comment on column RASD_ELEMENTS.endtagelementid
  is 'Id end tag if exists, other null';
comment on column RASD_ELEMENTS.source
  is 'G or null - generated, R - referenced (property is set from ref. element, attribute), V - value entered, changed (changes in rasd_forms, rasd_areas, rasd_fields,... are not transmitted into rasd_elements, rasd_attributi). ';
comment on column RASD_ELEMENTS.hiddenyn
  is 'Y-hidden, N,null-shown';
create index RASD_ELEMENTS_INX on RASD_ELEMENTS (FORMID, ELEMENTID);
create index RASD_ELEMENTS_INX3 on RASD_ELEMENTS (FORMID, ID);
alter table RASD_ELEMENTS
  add constraint RASD_ELEMENTS_UC unique (FORMID, ELEMENTID, ID, ELEMENT, TYPE);

prompt
prompt Creating table RASD_ELEMENTS_TEMPLATE
prompt =====================================
prompt
create table RASD_ELEMENTS_TEMPLATE
(
  coreid          NUMBER,
  element         VARCHAR2(100 BYTE),
  type            VARCHAR2(1 BYTE),
  elementid       NUMBER,
  pelementid      NUMBER,
  orderby         NUMBER,
  id              VARCHAR2(100 BYTE),
  nameid          VARCHAR2(100 BYTE),
  endtagelementid NUMBER,
  val_name        VARCHAR2(2000 BYTE),
  val_value       VARCHAR2(2000 BYTE),
  val_link        VARCHAR2(2000 BYTE),
  val_linkjs      VARCHAR2(2000 BYTE),
  val_type        VARCHAR2(2000 BYTE),
  val_format      VARCHAR2(2000 BYTE),
  hiddenyn        VARCHAR2(1 BYTE),
  source          VARCHAR2(1 BYTE),
  condition       VARCHAR2(500),
  orderbyval      VARCHAR2(500)
)
;
comment on column RASD_ELEMENTS_TEMPLATE.element
  is 'HTML_';
comment on column RASD_ELEMENTS_TEMPLATE.type
  is 'null-common, F-Form, B-Block, D-fielD, L-Label';
comment on column RASD_ELEMENTS_TEMPLATE.id
  is 'HTML';
comment on column RASD_ELEMENTS_TEMPLATE.nameid
  is 'HTML';
comment on column RASD_ELEMENTS_TEMPLATE.val_name
  is 'rf.nameid||''_NAME''';
comment on column RASD_ELEMENTS_TEMPLATE.val_value
  is 'rf.nameid||''_VALUE''';
comment on column RASD_ELEMENTS_TEMPLATE.val_link
  is 'rf.linkid';
comment on column RASD_ELEMENTS_TEMPLATE.val_linkjs
  is 'rf.linkid';
comment on column RASD_ELEMENTS_TEMPLATE.val_type
  is 'rf.type';
comment on column RASD_ELEMENTS_TEMPLATE.val_format
  is 'rf.format';

prompt
prompt Creating table RASD_ELEMENTS_TEMPORARY
prompt ======================================
prompt
create table RASD_ELEMENTS_TEMPORARY
(
  formid     NUMBER,
  elementid  NUMBER,
  orderby    NUMBER,
  element    VARCHAR2(100 BYTE),
  type       VARCHAR2(1 BYTE),
  tag        VARCHAR2(100 BYTE),
  id         VARCHAR2(100 BYTE),
  nameid     VARCHAR2(100 BYTE),
  content    VARCHAR2(4000 BYTE),
  startcode  VARCHAR2(4000 BYTE),
  endcode    VARCHAR2(4000 BYTE),
  attributes VARCHAR2(4000 BYTE)
)
;
create index RASD_ELEMENTS_TEMPORARY_IX1 on RASD_ELEMENTS_TEMPORARY (FORMID, ELEMENTID);

prompt
prompt Creating table RASD_ENGINES
prompt ===========================
prompt
create table RASD_ENGINES
(
  engineid NUMBER not null,
  server   VARCHAR2(30 BYTE) not null,
  client   VARCHAR2(25 BYTE),
  library  VARCHAR2(25 BYTE)
)
;
comment on column RASD_ENGINES.client
  is 'Only information';
comment on column RASD_ENGINES.library
  is 'Only information';

prompt
prompt Creating table RASD_FIELDS
prompt ==========================
prompt
create table RASD_FIELDS
(
  formid     NUMBER not null,
  fieldid    VARCHAR2(30 BYTE) not null,
  blockid    VARCHAR2(30 BYTE),
  type       VARCHAR2(1 BYTE) not null,
  format     VARCHAR2(30 BYTE),
  element    VARCHAR2(30 BYTE),
  hiddenyn   VARCHAR2(1 BYTE),
  orderby    NUMBER not null,
  pkyn       VARCHAR2(1 BYTE),
  selectyn   VARCHAR2(1 BYTE),
  insertyn   VARCHAR2(1 BYTE),
  updateyn   VARCHAR2(1 BYTE),
  deleteyn   VARCHAR2(1 BYTE),
  insertnnyn VARCHAR2(1 BYTE),
  notnullyn  VARCHAR2(1 BYTE),
  lockyn     VARCHAR2(1 BYTE),
  defaultval VARCHAR2(100 BYTE),
  elementyn  VARCHAR2(1 BYTE),
  nameid     VARCHAR2(100 BYTE),
  label      VARCHAR2(100 BYTE),
  linkid     VARCHAR2(30 BYTE),
  source     VARCHAR2(1 BYTE),
  rlobid     VARCHAR2(30 BYTE),
  rform      VARCHAR2(30 BYTE),
  rblockid   VARCHAR2(30 BYTE),
  rfieldid   VARCHAR2(30 BYTE),
  includevis VARCHAR2(30 BYTE)
)
;
comment on column RASD_FIELDS.blockid
  is 'Block defines group of fields.';
comment on column RASD_FIELDS.type
  is 'N number, C varchar, R rowid, D date.';
comment on column RASD_FIELDS.element
  is 'Show in  ON_GUIFIELD';
comment on column RASD_FIELDS.hiddenyn
  is 'Y-hidden, N,null-shown';
comment on column RASD_FIELDS.pkyn
  is 'To create WHERE for UPDATE or DELETE if V_SQL on ON-UPDATE, ON-DELETE null';
comment on column RASD_FIELDS.selectyn
  is 'To create data for GUI-client';
comment on column RASD_FIELDS.insertyn
  is 'To create insert  if V_SQL on ON-UPDATE, ON-DELETE null';
comment on column RASD_FIELDS.updateyn
  is 'To create update  if V_SQL on ON-UPDATE, ON-DELETE null';
comment on column RASD_FIELDS.deleteyn
  is 'Condition to delete row. Flaged fields must be null.';
comment on column RASD_FIELDS.insertnnyn
  is 'Triggers insert : INSERTYN=''D'' in DEFAULTYN=';
comment on column RASD_FIELDS.notnullyn
  is 'Mandatory field. Flaged fields must be <> null or there is an error before saveing.';
comment on column RASD_FIELDS.lockyn
  is 'If Y field is in revalidateing the data before updateing, N and null-no validateing';
comment on column RASD_FIELDS.defaultval
  is 'Default value for the field';
comment on column RASD_FIELDS.elementyn
  is 'If Y then it is going for the element on webclient gui.';
comment on column RASD_FIELDS.nameid
  is 'Element name (name or id); Label name (TD id="fieldid+_lab")';
comment on column RASD_FIELDS.label
  is 'If insertede it is shown instead of fieldid';
comment on column RASD_FIELDS.source
  is 'r-in usage, R - referenced, V - Value edited, changed.';
comment on column RASD_FIELDS.includevis
  is 'Flag that creates RECORD for CURRENT OBJECT  R(DISPLAY, READONLAY, ...)';
alter table RASD_FIELDS
  add constraint RASD_FIELD_PK unique (FORMID, FIELDID, BLOCKID);
alter table RASD_FIELDS
  add constraint RASD_CHECK_NAMEID
  check (NAMEID=upper(NAMEID));

prompt
prompt Creating table RASD_FILES
prompt =========================
prompt
create table RASD_FILES
(
  name         VARCHAR2(256 BYTE) not null,
  mime_type    VARCHAR2(128 BYTE),
  doc_size     NUMBER,
  dad_charset  VARCHAR2(128 BYTE),
  last_updated DATE,
  content_type VARCHAR2(128 BYTE),
  blob_content BLOB
)
;
alter table RASD_FILES
  add unique (NAME);

prompt
prompt Creating table RASD_FORMS
prompt =========================
prompt
create table RASD_FORMS
(
  formid            NUMBER not null,
  lobid             VARCHAR2(30 BYTE),
  form              VARCHAR2(30 BYTE) not null,
  version           NUMBER not null,
  label             VARCHAR2(100 BYTE),
  program           VARCHAR2(100 BYTE),
  text1id           NUMBER,
  text2id           NUMBER,
  referenceyn       VARCHAR2(1 BYTE),
  change            DATE,
  autodeletehtmlyn  VARCHAR2(1 BYTE),
  autocreaterestyn  VARCHAR2(1 BYTE) default 'Y',
  autocreatebatchyn VARCHAR2(1 BYTE) default 'Y'
)
;
comment on column RASD_FORMS.formid
  is 'Form - unique';
comment on column RASD_FORMS.lobid
  is 'Form owner';
comment on column RASD_FORMS.form
  is 'Form name - package name';
comment on column RASD_FORMS.label
  is 'Label - The form title';
comment on column RASD_FORMS.program
  is 'Form call (METOD="POST" ACTION="!<formname>.webclient")';
comment on column RASD_FORMS.text1id
  is 'Id text (G_TEXTS.ID)   download html';
comment on column RASD_FORMS.text2id
  is 'Id text (G_TEXTS.ID)   upload html';
comment on column RASD_FORMS.referenceyn
  is 'Y- form version, N or null';
comment on column RASD_FORMS.change
  is 'Last change';
comment on column RASD_FORMS.autodeletehtmlyn
  is 'Auto delete HTML content on Compile.';
comment on column RASD_FORMS.autocreaterestyn
  is 'If checked creates rest  program .rasd';
comment on column RASD_FORMS.autocreatebatchyn
  is 'If checked creates batch program .main';
create index RASD_FORMS_INX1 on RASD_FORMS (LOBID, FORM, REFERENCEYN, FORMID);
alter table RASD_FORMS
  add constraint RASD_FORMS_PK primary key (FORMID);
alter table RASD_FORMS
  add constraint RASD_FORMS_UC unique (LOBID, FORM, VERSION);

prompt
prompt Creating table RASD_FORMS_COMPILED
prompt ==================================
prompt
create table RASD_FORMS_COMPILED
(
  formid      NUMBER not null,
  engineid    NUMBER not null,
  change      DATE not null,
  compileyn   VARCHAR2(1 BYTE),
  application VARCHAR2(30 BYTE),
  owner       VARCHAR2(30 BYTE),
  editor      VARCHAR2(30 BYTE),
  lobid       VARCHAR2(30 BYTE)
)
;
comment on column RASD_FORMS_COMPILED.change
  is 'Date of first generation.';
comment on column RASD_FORMS_COMPILED.compileyn
  is 'Form to generate = Y (just one version of form can have flag to Y).';
comment on column RASD_FORMS_COMPILED.application
  is 'Application to group forms on content.';
comment on column RASD_FORMS_COMPILED.owner
  is 'Creator of the form.';
comment on column RASD_FORMS_COMPILED.editor
  is 'User who can use-edit form.';
comment on column RASD_FORMS_COMPILED.lobid
  is 'Line of bussiness';

prompt
prompt Creating table RASD_HINTS
prompt =========================
prompt
create table RASD_HINTS
(
  hintid NUMBER not null,
  form   VARCHAR2(30 BYTE),
  text   VARCHAR2(4000 BYTE) not null
)
;

prompt
prompt Creating table RASD_HTML_TEMPLATE
prompt =================================
prompt
create table RASD_HTML_TEMPLATE
(
  coreid        NUMBER,
  lobid         NUMBER,
  content_type  VARCHAR2(30),
  name          VARCHAR2(50),
  content       CLOB,
  content_order NUMBER
)
;
comment on column RASD_HTML_TEMPLATE.content_type
  is 'FORM, ANGULAR, ...';
comment on column RASD_HTML_TEMPLATE.name
  is 'name of source';
comment on column RASD_HTML_TEMPLATE.content_order
  is 'in case if there is the sam name ...';

prompt
prompt Creating table RASD_LINK_PARAMS
prompt ===============================
prompt
create table RASD_LINK_PARAMS
(
  linkid  VARCHAR2(30 BYTE) not null,
  paramid VARCHAR2(30 BYTE) not null,
  type    VARCHAR2(20 BYTE) not null,
  orderby NUMBER,
  formid  NUMBER not null,
  blockid VARCHAR2(30 BYTE),
  fieldid VARCHAR2(30 BYTE),
  namecid VARCHAR2(100 BYTE),
  code    VARCHAR2(100 BYTE),
  value   VARCHAR2(500 BYTE),
  rlobid  VARCHAR2(30 BYTE),
  rform   VARCHAR2(30 BYTE),
  rlinkid VARCHAR2(30 BYTE)
)
;
comment on column RASD_LINK_PARAMS.paramid
  is 'Parameter id';
comment on column RASD_LINK_PARAMS.type
  is 'OUT, IN - FORM (INTO, WHERE), TEXT, TRUE, FALSE';
comment on column RASD_LINK_PARAMS.fieldid
  is '(Name -> PFORMID=1234 <- id od this field)';
comment on column RASD_LINK_PARAMS.namecid
  is 'Name of parameter on the other form';
comment on column RASD_LINK_PARAMS.value
  is 'For statis parameters - constants.';
alter table RASD_LINK_PARAMS
  add constraint RASD_LINK_PARAMS_PK primary key (FORMID, LINKID, PARAMID);

prompt
prompt Creating table RASD_LINKS
prompt =========================
prompt
create table RASD_LINKS
(
  formid   NUMBER not null,
  linkid   VARCHAR2(30 BYTE) not null,
  link     VARCHAR2(100 BYTE) not null,
  type     VARCHAR2(20 BYTE) not null,
  location VARCHAR2(30 BYTE),
  text     VARCHAR2(4000 BYTE),
  source   VARCHAR2(1 BYTE),
  hiddenyn VARCHAR2(1 BYTE),
  rlobid   VARCHAR2(30 BYTE),
  rform    VARCHAR2(30 BYTE),
  rlinkid  VARCHAR2(30 BYTE)
)
;
comment on column RASD_LINKS.linkid
  is 'Code';
comment on column RASD_LINKS.link
  is 'Name';
comment on column RASD_LINKS.type
  is 'S-SQL, T-Text, U-URL, F-Forma, C-check true/false.';
comment on column RASD_LINKS.location
  is 'N-New window, I- In the same window';
comment on column RASD_LINKS.text
  is 'SQL or URL or form name';
comment on column RASD_LINKS.source
  is 'r-in usage, R - referenced, V - Value edited, changed.';
comment on column RASD_LINKS.hiddenyn
  is 'Y-hidden, N,null-shown';
alter table RASD_LINKS
  add constraint RASD_LINKS_PK primary key (FORMID, LINKID);

prompt
prompt Creating table RASD_LOG
prompt =======================
prompt
create table RASD_LOG
(
  formid  NUMBER,
  action  VARCHAR2(100),
  timstmp TIMESTAMP(6),
  compid  NUMBER,
  other   VARCHAR2(1000),
  program VARCHAR2(100)
)
;

prompt
prompt Creating table RASD_PAGES
prompt =========================
prompt
create table RASD_PAGES
(
  formid   NUMBER not null,
  page     NUMBER not null,
  blockid  VARCHAR2(30 BYTE),
  fieldid  VARCHAR2(30 BYTE),
  rlobid   VARCHAR2(30 BYTE),
  rform    VARCHAR2(30 BYTE),
  rblockid VARCHAR2(30 BYTE),
  rfieldid VARCHAR2(30 BYTE)
)
;

prompt
prompt Creating table RASD_PRVS_LOB
prompt ============================
prompt
create table RASD_PRVS_LOB
(
  lobid    VARCHAR2(30 BYTE) not null,
  lob      VARCHAR2(100 BYTE) not null,
  dadurl   VARCHAR2(100 BYTE) not null,
  starturl VARCHAR2(100 BYTE)
)
;
comment on column RASD_PRVS_LOB.lobid
  is 'Line of bussiness using applications - forms.';
comment on column RASD_PRVS_LOB.lob
  is 'Line of bussiness description.';
comment on column RASD_PRVS_LOB.dadurl
  is 'Name of PL/SQL DAD. URL shown in browser.';
comment on column RASD_PRVS_LOB.starturl
  is 'Starting  URL.';

prompt
prompt Creating table RASD_REFERENCES
prompt ==============================
prompt
create table RASD_REFERENCES
(
  formid       NUMBER not null,
  includeyn    VARCHAR2(1 BYTE) default 'Y' not null,
  hiddenyn     VARCHAR2(1 BYTE) default 'N' not null,
  nomatheryn   VARCHAR2(1 BYTE) default 'N' not null,
  engineid     NUMBER,
  lobid        VARCHAR2(30 BYTE),
  application  VARCHAR2(30 BYTE),
  elementsyn   VARCHAR2(1 BYTE) default 'N' not null,
  attributesyn VARCHAR2(1 BYTE) default 'N' not null,
  fieldsyn     VARCHAR2(1 BYTE) default 'N' not null,
  triggersyn   VARCHAR2(1 BYTE) default 'N' not null,
  linksyn      VARCHAR2(1 BYTE) default 'N' not null,
  attribute    VARCHAR2(30 BYTE),
  id           VARCHAR2(30 BYTE),
  pid          VARCHAR2(30 BYTE),
  element      VARCHAR2(30 BYTE),
  type         VARCHAR2(1 BYTE),
  paramid      VARCHAR2(30 BYTE),
  linkid       VARCHAR2(30 BYTE),
  triggerid    VARCHAR2(30 BYTE),
  fieldid      VARCHAR2(30 BYTE),
  blockid      VARCHAR2(30 BYTE),
  rlobid       VARCHAR2(30 BYTE),
  rform        VARCHAR2(30 BYTE),
  rblockid     VARCHAR2(30 BYTE),
  rfieldid     VARCHAR2(30 BYTE),
  rtriggerid   VARCHAR2(30 BYTE),
  rid          VARCHAR2(30 BYTE),
  rpid         VARCHAR2(30 BYTE),
  rlinkid      VARCHAR2(30 BYTE),
  rparamid     VARCHAR2(30 BYTE),
  levelon      NUMBER default 0 not null
)
;
comment on column RASD_REFERENCES.formid
  is 'Id forme';
comment on column RASD_REFERENCES.hiddenyn
  is 'Y/N';
comment on column RASD_REFERENCES.nomatheryn
  is 'Y/N';
comment on column RASD_REFERENCES.pid
  is 'Parent id';
comment on column RASD_REFERENCES.rpid
  is 'Parent id in referenced form';
comment on column RASD_REFERENCES.levelon
  is '0,10,20,30-f,a,e, engine';

prompt
prompt Creating table RASD_TEXTS
prompt =========================
prompt
create table RASD_TEXTS
(
  textid NUMBER,
  text   CLOB
)
;
comment on column RASD_TEXTS.textid
  is 'select (nvl(max,0)+1) from dual;';

prompt
prompt Creating table RASD_TRANSLATES
prompt ==============================
prompt
create table RASD_TRANSLATES
(
  text      VARCHAR2(1000 BYTE),
  lang      VARCHAR2(30 BYTE),
  translate VARCHAR2(1000 BYTE)
)
;

prompt
prompt Creating table RASD_TRIGGERS
prompt ============================
prompt
create table RASD_TRIGGERS
(
  formid    NUMBER not null,
  blockid   VARCHAR2(60 BYTE),
  triggerid VARCHAR2(30 BYTE) not null,
  plsql     CLOB,
  plsqlspec CLOB,
  source    VARCHAR2(1 BYTE),
  hiddenyn  VARCHAR2(1 BYTE),
  rlobid    VARCHAR2(30 BYTE),
  rform     VARCHAR2(30 BYTE),
  rblockid  VARCHAR2(30 BYTE)
)
;
comment on column RASD_TRIGGERS.triggerid
  is 'Trigger name';
comment on column RASD_TRIGGERS.plsql
  is 'SQL coda (PL\SQL)';
comment on column RASD_TRIGGERS.plsqlspec
  is 'Specification for public variables, procedures and functions';
comment on column RASD_TRIGGERS.source
  is 'r-in usage, R - referenced, V - Value edited, changed.';
comment on column RASD_TRIGGERS.hiddenyn
  is 'Y-hidden, N,null-shown';
alter table RASD_TRIGGERS
  add constraint RASD_TRIGGERS_C_UC unique (FORMID, TRIGGERID, BLOCKID);

prompt
prompt Creating table RASD_TRIGGERS_CODE_TYPES
prompt =======================================
prompt
create table RASD_TRIGGERS_CODE_TYPES
(
  tctype      VARCHAR2(30 BYTE) not null,
  description VARCHAR2(100 BYTE),
  language    VARCHAR2(1 BYTE) not null,
  tclevel     VARCHAR2(1 BYTE) not null
)
;
comment on column RASD_TRIGGERS_CODE_TYPES.language
  is 'P-PLSQL, S-SQL, ...';
comment on column RASD_TRIGGERS_CODE_TYPES.tclevel
  is 'F-FORM, B-BLOCK, D-FIELD';

prompt
prompt Creating table RASD_TRIGGERS_TEMPLATE
prompt =====================================
prompt
create table RASD_TRIGGERS_TEMPLATE
(
  lobid     VARCHAR2(30 BYTE),
  triggerid VARCHAR2(30 BYTE) not null,
  preplsql  CLOB,
  onplsql   CLOB,
  postplsql CLOB
)
;
comment on column RASD_TRIGGERS_TEMPLATE.lobid
  is 'Line Of Business if null default for all';
comment on column RASD_TRIGGERS_TEMPLATE.triggerid
  is 'Trigger name';
comment on column RASD_TRIGGERS_TEMPLATE.preplsql
  is 'PLSQL code before default genereted code. ADD NEW LINE AT THE END OF CODE!!!';
comment on column RASD_TRIGGERS_TEMPLATE.onplsql
  is 'PLSQL on before default genereted code - replaces generated code. ADD NEW LINE AT THE END OF CODE!!!';
comment on column RASD_TRIGGERS_TEMPLATE.postplsql
  is 'PLSQL code post default genereted code. ADD NEW LINE AT THE END OF CODE!!!';

prompt
prompt Creating table RASD_TRIGGERS_TMP
prompt ================================
prompt
create table RASD_TRIGGERS_TMP
(
  formid    NUMBER not null,
  blockid   VARCHAR2(60 BYTE),
  triggerid VARCHAR2(30 BYTE) not null,
  plsql     VARCHAR2(4000),
  plsqlspec VARCHAR2(4000),
  source    VARCHAR2(1 BYTE),
  hiddenyn  VARCHAR2(1 BYTE),
  rlobid    VARCHAR2(30 BYTE),
  rform     VARCHAR2(30 BYTE),
  rblockid  VARCHAR2(30 BYTE)
)
;

prompt
prompt Creating sequence COMPSEQ
prompt =========================
prompt
create sequence COMPSEQ
minvalue 1
maxvalue 9999999999999999999999999999
start with 14949
increment by 1
cache 20;


prompt Done
spool off
set define on
