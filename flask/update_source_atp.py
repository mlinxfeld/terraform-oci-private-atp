import os
import cx_Oracle

def update_source_atp():
    os.environ['TNS_ADMIN'] = '/usr/lib/oracle/18.3/client64/lib/network/admin'
    print("Connecting to source ATP ad ADMIN...")
    connection = cx_Oracle.connect('admin', 'atp_password', 'atp_alias')
    cursor = connection.cursor()
    print("1. Creating application user (ATP_USER)...") 
    rs = cursor.execute("create user {} identified by {}".format('atp_user','atp_password'))
    print("2. Granting minimal privileges to application user (ATP_USER)...") 
    rs = cursor.execute("grant create session to {}".format('atp_user'))
    rs = cursor.execute("grant create table to {}".format('atp_user'))
    rs = cursor.execute("grant create sequence to {}".format('atp_user'))
    rs = cursor.execute("grant unlimited tablespace to {}".format('atp_user'))  
    print("Closing connection to source ATP...")
    cursor.close()
    connection.close()
    print("Connecting to source ATP as ATP_USER...")
    connection2 = cx_Oracle.connect('atp_user', 'atp_password', 'atp_alias')
    cursor2 = connection2.cursor()
    print("1. Creating foggykitchen_table table (ATP_USER)...")     
    rs = cursor2.execute('''create table foggykitchen_table (id number, my_key varchar2(1000), my_data varchar2(1000), CONSTRAINT my_data_pk PRIMARY KEY (id))''')
    print("2. Inserting records to foggykitchen_table  (ATP_USER)...")     
    rs = cursor2.execute('''insert into foggykitchen_table values (1,'machine1','1234567890')''')
    rs = cursor2.execute('''insert into foggykitchen_table values (2,'machine2','2345678901')''')
    rs = cursor2.execute('''insert into foggykitchen_table values (3,'machine3','3456789012')''')
    rs = cursor2.execute('COMMIT')
    print("3. Creating foggykitchen_seq sequence in application user schema (ATP_USER)...")    
    rs = cursor2.execute("create sequence foggykitchen_seq start with 3 increment by 1 nocache nocycle")
    rs = cursor2.execute("select foggykitchen_seq.nextval from DUAL")
    print("Closing connection to source ATP...") 
    cursor2.close()
    connection2.close()
     
if __name__ == "__main__":
    update_source_atp()