
# Database

ASMRchive utilizes a PostgreSQL database. This database is containerized.

## Configuration
The .env.sample file provides a basic configuration example. You can copy this file to "./.env" and edit that file with the username, password, host port, and other configurations. 

### Configuration Values
- POSTGRES_USER - Default username for accessing the database  
- POSTGRES_PASS - The password for the POSTGRES_USER
- POSTGRES_DB - The database name. Usually this should be left as ASMRchive.
- DB_PORT - The port the container host will expect database traffic to come in on. Default is 5432.

## TODO
- Create a database migration procedure to handle changes to the database schema. I currently plan to use Alembic.
- Implement automated backups with a simple rollback procedure.
- Design thorough tests for each migration to ensure database functionality
- Incorporate CI tests to verify migrations work in a clone of production before allowing any pushes to master.