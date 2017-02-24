DROP DATABASE IF EXISTS MCP; CREATE DATABASE MCP CHARACTER SET utf8 COLLATE utf8_unicode_ci;
CREATE USER 'archivematica'@'localhost' IDENTIFIED BY 'demo';
GRANT ALL ON MCP.* TO 'archivematica'@'localhost';
