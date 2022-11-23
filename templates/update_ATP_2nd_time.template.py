import os
import cx_Oracle

def update_source_atp():
    print("========================================")
    print("Executing update_ATP_2nd_time.py script.")
    print("========================================")
    os.environ['TNS_ADMIN'] = '/usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin'
    print("Connecting to source ATP as ${ATP_USER_name}...")
    connection = cx_Oracle.connect('${ATP_USER_name}', '${ATP_USER_password}', '${ATP_alias}')
    cursor = connection.cursor()
    print("Inserting records to foggykitchen_table (${ATP_USER_name})...")     
    rs = cursor.execute('''insert into foggykitchen_table values (4,'machine4','4444444444')''')
    rs = cursor.execute('''insert into foggykitchen_table values (5,'machine5','5555555555')''')
    rs = cursor.execute('''insert into foggykitchen_table values (6,'machine6','6666666666')''')
    rs = cursor.execute('COMMIT')
    print("Closing connection to source ATP...") 
    cursor.close()
    connection.close()
    print("========================================")
    print("update_ATP_2nd_time.py finshed.")
    print("========================================")
     
if __name__ == "__main__":
    update_source_atp()