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
