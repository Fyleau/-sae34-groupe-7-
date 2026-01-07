-- init_db.sql for PostgreSQL with FreeRADIUS schema

CREATE TABLE radcheck (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '==',
  value TEXT NOT NULL DEFAULT ''
);

CREATE TABLE radreply (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '=',
  value TEXT NOT NULL DEFAULT ''
);

CREATE TABLE radusergroup (
  id SERIAL PRIMARY KEY,
  username TEXT NOT NULL DEFAULT '',
  groupname TEXT NOT NULL DEFAULT '',
  priority INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE radgroupcheck (
  id SERIAL PRIMARY KEY,
  groupname TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '==',
  value TEXT NOT NULL DEFAULT ''
);

CREATE TABLE radgroupreply (
  id SERIAL PRIMARY KEY,
  groupname TEXT NOT NULL DEFAULT '',
  attribute TEXT NOT NULL DEFAULT '',
  op VARCHAR(2) NOT NULL DEFAULT '=',
  value TEXT NOT NULL DEFAULT ''
);

-- Test User
INSERT INTO radcheck (username, attribute, op, value) VALUES ('testuser', 'Cleartext-Password', ':=', 'testpass');
INSERT INTO radcheck (username, attribute, op, value) VALUES ('testuser2', 'Cleartext-Password', ':=', 'testpass2');

CREATE TABLE radpostauth (
  id SERIAL PRIMARY KEY,
  username text NOT NULL default '',
  pass text NOT NULL default '',
  reply text NOT NULL default '',
  authdate timestamp with time zone NOT NULL default 'now()'
);

CREATE TABLE radacct (
  radacctid SERIAL PRIMARY KEY,
  acctsessionid text NOT NULL default '',
  acctuniqueid text NOT NULL default '',
  username text NOT NULL default '',
  groupname text NOT NULL default '',
  realm text default '',
  nasipaddress inet NOT NULL default '0.0.0.0',
  nasportid text default '',
  nasporttype text default '',
  acctstarttime timestamp with time zone,
  acctupdatetime timestamp with time zone,
  acctstoptime timestamp with time zone,
  acctinterval interval,
  acctsessiontime bigint,
  acctauthentic text default '',
  connectinfo_start text default '',
  connectinfo_stop text default '',
  acctinputoctets bigint,
  acctoutputoctets bigint,
  calledstationid text default '',
  callingstationid text default '',
  acctterminatecause text default '',
  servicetype text default '',
  framedprotocol text default '',
  framedipaddress inet default NULL
);
