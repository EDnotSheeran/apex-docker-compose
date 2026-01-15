# Oracle APEX with Docker Compose

This project provides a simple way to run **Oracle APEX 24.2** using Docker Compose with an Oracle Free database and Oracle REST Data Services (ORDS).

---

## 🚀 Getting Started

### 1. Download APEX

First, download the file `apex_24.2.zip` from the [Oracle APEX Downloads page](https://www.oracle.com/tools/downloads/apex-downloads.html).

Extract the contents into the `./apex` folder of this project:

```bash
unzip apex_24.1.zip -d ./apex
```

Your folder structure should now look like this:

```
.
├── apex
│   ├── apexins.sql
│   ├── builder
│   └── ...
├── docker-compose.yml
└── ...
```

---

### 2. Start the Oracle Database container

Run the following command to start the Oracle database container:

```bash
docker-compose up -d oracle-db
```

This will start the Oracle database (container name: `oracle-db`) and initialize the environment.

⚠️ **Important:** This step only starts the database. The APEX installation must complete before starting the `ords` container.

---

### 3. Wait for APEX Installation

After the `oracle-db` container is running, APEX will begin installing automatically into the Oracle database.

This process can take several minutes. You can monitor the logs using:

```bash
docker logs -f oracle-db
```

Wait until the logs show a message similar to:

```
APEX installation completed successfully
```

Then create the admin user for your instance:

```
docker exec -it oracle-db bash
cd /opt/oracle/apex
sqlplus / as sysdba
ALTER SESSION SET CONTAINER=FREEPDB1;
@apxchpwd.sql
```

Only then proceed to the next step.

---

### 4. Start the ORDS container

Once APEX has been installed, start the ORDS container:

```bash
docker-compose up -d ords
```

ORDS (container name: `ords`) will now connect to the database and serve the APEX web interface.

Access Oracle APEX at:

```
http://localhost:8080/ords/
```

the apex instace admin will be:

- workspace: INTERNAL
- user: ADMIN
- password: MySecret123!

---

## 💾 Data Persistence

This setup uses Docker volumes for data storage:

- `oracle-data`: stores database files for Oracle Free
- `ords-config`: stores ORDS configuration files

You can inspect or manage volumes with:

```bash
docker volume ls
docker volume inspect oracle-data
```

---

## ♻️ Restarting Services

To restart the containers:

```bash
docker-compose restart oracle-db
docker-compose restart ords
```

If ORDS fails to start on the first run, this is expected. Just wait for APEX installation to finish and try again.

---
## 🎁 Extra

If you want to host your workspace on cloudflared, fisrt create a tunel pointing to the apex service on:

```
  http://host.docker.internal:8080
```

Then on `settings.xml` add the following entry?
```
  <entry key="security.externalSessionTrustedOrigins">https://yoursite.com.br</entry>
```


apex.selfhost.site

---

## 📜 License

This project uses the official Oracle container images:

- [`gvenzl/oracle-free:23.6-full`](https://hub.docker.com/r/gvenzl/oracle-free)
- [`container-registry.oracle.com/database/ords:25.1.0` + custom ORDS setup]

Oracle APEX and ORDS are free to use under the [Oracle Free Use Terms and Conditions](https://www.oracle.com/downloads/licenses/oracle-free-license.html).
