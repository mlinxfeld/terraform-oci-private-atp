from flask import Flask, render_template, url_for, request
import os
import socket
import cx_Oracle
import json

app = Flask(__name__)

@app.route('/')
def oracleatpcheck():
     os.environ['TNS_ADMIN'] = '/usr/lib/oracle/${oracle_instant_client_version_short}/client64/lib/network/admin'
     connection = cx_Oracle.connect('${ATP_USER_name}', '${ATP_USER_password}', '${ATP_alias}')
     cursor = connection.cursor()
     rs = cursor.execute("select id, my_key, my_data from foggykitchen_table order by id")
     rows = rs.fetchall()
     json_output = json.dumps(rows) 
     cursor.close()
     connection.close()  

     return render_template('index.html', json_output=json_output, dbname='${dbname}')

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80, debug=True)

