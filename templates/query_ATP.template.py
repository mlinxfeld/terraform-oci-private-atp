import os
import cx_Oracle
import json

def query_source_atp():
    print("========================================")
    print("Executing query_ATP.py script.")
    print("========================================")
    os.environ['TNS_ADMIN'] = '/usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin'
    print("Connecting to source ATP as ${ATP_USER_name}...")
    connection = cx_Oracle.connect('${ATP_USER_name}', '${ATP_USER_password}', '${ATP_alias}')
    cursor = connection.cursor()
    print("Fetching data from foggykitchen_table table (admin)...")
    rs = cursor.execute("select id, my_key, my_data from foggykitchen_table order by id")
    rows = rs.fetchall()
    json_output = json.dumps(rows)
    print(json_output)
    print("Closing connection toto source ATP...")
    cursor.close()
    connection.close()
    print("========================================")
    print("query_ATP.py finshed.")
    print("========================================")

if __name__ == "__main__":
    query_source_atp()