#!/bin/bash

echo "Installing Apex..."

cd /opt/oracle/apex

# Install APEX
sqlplus sys/${ORACLE_PASSWORD}@FREEPDB1 as sysdba @/opt/oracle/apex/apexins.sql SYSAUX SYSAUX TEMP /i/

echo "Unlocking APEX_PUBLIC_USER..."

sqlplus sys/${ORACLE_PASSWORD}@FREEPDB1 as sysdba <<EOF
ALTER USER APEX_PUBLIC_USER IDENTIFIED BY ${ORACLE_PASSWORD} ACCOUNT UNLOCK;
GRANT CREATE SESSION TO APEX_PUBLIC_USER;
EOF