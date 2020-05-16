import mysql.connector

conn = None
cursor = None

try:
    conn = mysql.connector.connect(database="mysql", user="root")
    cursor = conn.cursor(prepared=True)
    cursor.execute("CREATE TABLE IF NOT EXISTS products (name VARCHAR(40), price INT)")
    params = [("bike", 10900),
              ("shoes", 7400),
              ("phone", 29500)]
    cursor.executemany("INSERT INTO products VALUES (%s, %s)", params)
    params = ("shoes",)
    cursor.execute("SELECT * FROM products WHERE name = %s", params)
    print(cursor.fetchall()[0][1])
finally:
    if cursor is not None:
        cursor.close()
    if conn is not None:
        conn.close()