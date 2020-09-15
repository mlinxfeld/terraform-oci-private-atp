import os
import cx_Oracle

def update_source_atp():
    os.environ['TNS_ADMIN'] = '/usr/lib/oracle/18.3/client64/lib/network/admin'
    print("Connecting to source ATP as ATP_USER...")
    connection2 = cx_Oracle.connect('atp_user', 'atp_password', 'atp_alias')
    cursor2 = connection2.cursor()
    print("Inserting records to foggykitchen_table  (ATP_USER)...")     
    rs = cursor2.execute('''insert into foggykitchen_table values (4,'machine4','4444444444')''')
    rs = cursor2.execute('''insert into foggykitchen_table values (5,'machine5','5555555555')''')
    rs = cursor2.execute('''insert into foggykitchen_table values (6,'machine6','6666666666')''')
    rs = cursor2.execute('COMMIT')
    print("Closing connection to source ATP...") 
    cursor2.close()
    connection2.close()
     
if __name__ == "__main__":
    update_source_atp()