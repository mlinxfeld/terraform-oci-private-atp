import os
import cx_Oracle
import json

def query_source_atp():
    os.environ['TNS_ADMIN'] = '/usr/lib/oracle/18.3/client64/lib/network/admin'
    print("Connecting to source ATP ad ATP_USER...")
    connection2 = cx_Oracle.connect('atp_user', 'BEstrO0ng_#11', 'fkatpdb1_medium')
    cursor2 = connection2.cursor()
    print("Fetching data from foggykitchen_table table (ATP_USER)...")
    rs = cursor2.execute("select id, my_key, my_data from foggykitchen_table order by id")
    rows = rs.fetchall()
    json_output = json.dumps(rows)
    print(json_output)
    print("Closing connection toto source ATP...")
    cursor2.close()
    connection2.close()

if __name__ == "__main__":
    query_source_atp()