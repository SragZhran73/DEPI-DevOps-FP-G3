import pymysql
import os

def lambda_handler(event, context):
    # Fetch environment variables set in Lambda configuration
    rds_host = os.getenv('RDS_HOST')
    rds_username = os.getenv('RDS_USERNAME')
    rds_password = os.getenv('RDS_PASSWORD')
    rds_db_name = os.getenv('RDS_DB_NAME')

    try:
        # Establishing connection to the MySQL RDS
        connection = pymysql.connect(
            host=rds_host,
            user=rds_username,
            password=rds_password,
            database=rds_db_name,
            connect_timeout=5
        )
        print("Connection succeeded!")

        # Read and execute SQL scripts
        with open('/tmp/table-set.sql', 'r') as file:
            bd_table = file.read()
        with open('/tmp/data-set.sql', 'r') as file:
            bd_filling = file.read()

        cursor = connection.cursor()
        cursor.execute(bd_table)
        cursor.execute(bd_filling)
        print("Query execution confirmed!")

        connection.commit()

    except Exception as e:
        print(f"Error: {str(e)}")
    finally:
        connection.close()
