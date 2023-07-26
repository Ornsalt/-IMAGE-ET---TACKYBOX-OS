#!/usr/bin/env python3


"""
Created the 09/11/2022
Mysql utilities for the Tackybox project.
Due to the structure of the repo (each service in a folder),
this file is present in root instead of each folder, with a hardlink for docker
"""

import mysql.connector

from datetime import datetime

# convert string from user:pwd@ip:db to a mysql connector or None.
def mysql_connection(sql_url:str):
    conn = None
    cursor = None
    credentials, location = sql_url.split("@")
    user, pwd = credentials.split(":")
    ip, db = location.split(":")

    try:
        conn = mysql.connector.connect(host=ip,
                        database=db,
                        user=user,
                        password=pwd)
        cursor = conn.cursor()
        print("We have a db cursor")
    except:
        print("No cursor")
        return None, None
    return conn, cursor

# Insert in Database a log with the 3 following informations.
# Datetime, Type (INFO, WARN, or ERR), and message
def insert_log(db_conn, db_cursor, typelog:str, message:str):
    if (not db_cursor):
        return

    now = datetime.now()
    insert_stmt = "INSERT INTO Logs(EventTime, Type, Message) VALUES (%s, %s, %s)"
    data = (now.strftime('%Y-%m-%d %H:%M:%S'), typelog, message)
    db_cursor.execute(insert_stmt, data)
    db_conn.commit()
    print("Log %s : %s inserted" % (typelog, message))

# Insert in Database key data about an image
# See documentation for more about the fields
def insert_image(db_conn, db_cursor, uid:str,
                name:str, birthday:str, moda:str, sop_uid:str):
    if (not db_cursor):
        return
    insert_stmt = ("INSERT INTO Images(Uid, Name, Birthday, Type, SOPInstanceUID, Status) " 
                + "VALUES (%s, %s, %s, %s, %s, 'COMING')")
    print("Insert stmt =", insert_stmt)
    data = (uid, name, birthday, moda, sop_uid)
    print(data)
    db_cursor.execute(insert_stmt, data)
    print(db_cursor)
    db_conn.commit()
    print("Image %s %s inserted" % (sop_uid, name))

# Insert in Database key data about all images in folder
# Used by the tackybox-mother
# data is a list of tuple containing informations passed as parameters in insert_image
# See documentation for more about the fields
def insert_all_images(db_conn, db_cursor, data):
    if (not db_cursor):
        return
    insert_log(db_conn, db_cursor, "INFO", "Debut du chargement des images en base de donnees")
    insert_stmt = ("INSERT INTO Images(Uid, Name, Birthday, Type, SOPInstanceUID, Status) " 
                + "VALUES (%s, %s, %s, %s, %s, 'COMING')")
    print("Insert stmt =", insert_stmt)
    db_cursor.executemany(insert_stmt, data)
    print(db_cursor)
    db_conn.commit()
    insert_log(db_conn, db_cursor, "INFO", "Fin du chargement des images en base de donnees")
    print("Bunch of image added")

# Flush database to remain consistent with emptied examens directory
# if safety=True, inform the box was force emptied
# else, inform the rsync was successful on at least one target
def flush_images_db(db_conn, db_cursor, safety=False):
    if (not db_cursor):
        return
    db_cursor.execute("TRUNCATE TABLE Images")
    print(db_cursor)
    db_conn.commit()
    if safety:
        insert_log(db_conn, db_cursor, "ERR", "Activation de la mesure SAFETY. Vidage de force de la box pour eviter un effet bouchon")
    else:
        insert_log(db_conn, db_cursor, "INFO", "Les images ont atteint au moins une destination. Elles sont supprimees de la box")

# Update in Database the status of all images
# Possibles values are "SENDING" or "SENDING FAILED"
# Executed just after the listdir in RsyncWrapper
def update_images_status(db_conn, db_cursor, status:str):
    if (not db_cursor):
        return
    update_stmt = ("UPDATE Images SET Status = %s")
    print("update stmt =", update_stmt)
    data = (status, ) # Ugly af, but cursor needs it
    print(data)
    db_cursor.execute(update_stmt, data)
    print(db_cursor)
    db_conn.commit()
    print("All images status updated to %s" % (status))

# Update in Database the status of images
# Possibles values are "SENDING" or "SENDING FAILED"
def update_image_status(db_conn, db_cursor, status:str, sop_uid:str):
    if (not db_cursor):
        return
    update_stmt = ("UPDATE Images SET Status = %s WHERE SOPInstanceUID = %s")
    print("update stmt =", update_stmt)
    data = (status, sop_uid)
    print(data)
    db_cursor.execute(update_stmt, data)
    print(db_cursor)
    db_conn.commit()
    print("Image %s status updated to %s" % (sop_uid, status))

# Delete record about examUID
# Used when sending was successful on at least one target
def delete_image(db_conn, db_cursor, sop_uid:str):
    if (not db_cursor):
        return
    delete_stmt = ("DELETE FROM Images WHERE SOPInstanceUID = %s")
    print("delete stmt =", delete_stmt)
    data = (sop_uid, ) # Ugly af, but cursor needs it
    print(data)
    db_cursor.execute(delete_stmt, data)
    print(db_cursor)
    db_conn.commit()
    print("Image %s deleted" % (sop_uid))

# Select on the log table to show the database this connection is still used.
def select_alive(db_cursor):
    if (not db_cursor):
        return
    select_stmt = ("SELECT * FROM Logs LIMIT 5")
    print("alive stmt =", select_stmt)
    db_cursor.execute(select_stmt)
    print(db_cursor)
    db_cursor.fetchall()
    return

# Select on the Images table to know if it is the first image
# Return a either a record or None
def select_uid(db_cursor, uid:str):
    if (not db_cursor):
        return None
    select_stmt = ("SELECT Uid FROM Images WHERE Uid = %s")
    print("select stmt =", select_stmt)
    data = (uid, ) # Ugly af, but cursor needs it
    db_cursor.execute(select_stmt, data)
    print(db_cursor)
    record = db_cursor.fetchone() # Either a tuple or None
    return record