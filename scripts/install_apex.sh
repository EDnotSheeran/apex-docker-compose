#!/bin/bash

echo "Installing Apex..."

cd /opt/oracle/apex

# Install APEX
sqlplus sys/${ORACLE_PASSWORD}@FREEPDB1 as sysdba @apexins.sql SYSAUX SYSAUX TEMP /i/

echo "Unlocking APEX_PUBLIC_USER..."

sqlplus sys/${ORACLE_PASSWORD}@FREEPDB1 as sysdba <<EOF
ALTER USER APEX_PUBLIC_USER IDENTIFIED BY ${ORACLE_PASSWORD} ACCOUNT UNLOCK;
GRANT CREATE SESSION TO APEX_PUBLIC_USER;
EOF

echo "Creating ADMIN user..."

---------------
# Define the default password for the APEX ADMIN user
sqlplus sys/${ORACLE_PASSWORD}@FREEPDB1 as sysdba <<EOF
BEGIN
  APEX_UTIL.SET_SECURITY_GROUP_ID(10); -- Workspace INTERNAL
  APEX_UTIL.CREATE_USER(
    p_user_name                   => 'ADMIN',
    p_email_address               => 'admin@example.com',
    p_web_password                => 'MySecret123!',
    p_developer_privs            => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
    p_change_password_on_first_use => 'N'
  );
END;
/
EXIT;
EOF