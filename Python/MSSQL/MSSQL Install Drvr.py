# pip install pymssql

# pip list

import pymssql

conn = pymssql.connect(
    server='<server-address>',
    user='<username>',
    password='<password>',
    database='<database-name>',
    as_dict=True
)


SQL_QUERY = """
SELECT 
TOP 5 c.CustomerID, 
c.CompanyName, 
COUNT(soh.SalesOrderID) AS OrderCount 
FROM 
SalesLT.Customer AS c 
LEFT OUTER JOIN SalesLT.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID 
GROUP BY 
c.CustomerID, 
c.CompanyName 
ORDER BY 
OrderCount DESC;
"""


cursor = conn.cursor()
cursor.execute(SQL_QUERY)


records = cursor.fetchall()
for r in records:
    print(f"{r['CustomerID']}\t{r['OrderCount']}\t{r['CompanyName']}")