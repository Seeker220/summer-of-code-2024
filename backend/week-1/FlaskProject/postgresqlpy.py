import psycopg2
def all_tables():
    conn = psycopg2.connect("dbname=pos user=postgres password=postgres")
    cur = conn.cursor()
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables
        WHERE table_schema = 'public';
    """)
    tables = cur.fetchall()
    cur.close()
    conn.close()
    return [i[0] for i in tables]
def table_headers(tname):
    conn = psycopg2.connect("dbname=pos user=postgres password=postgres")
    cur = conn.cursor()
    cur.execute("""
        SELECT column_name 
        FROM information_schema.columns
        WHERE table_schema = 'public' AND table_name = %s;
    """, (tname,))
    headers = cur.fetchall()
    cur.close()
    conn.close()
    return [i[0] for i in headers]
def totalinventoryvalue():
    conn = psycopg2.connect("dbname=pos user=postgres password=postgres")
    cur = conn.cursor()
    query = """
        SELECT SUM(item_price * item_qty)
        FROM inventoryitem;
    """
    cur.execute(query)
    val=float(cur.fetchone()[0])
    cur.close()
    conn.close()
    return val
def customertrans(c_id):
    conn = psycopg2.connect("dbname=pos user=postgres password=postgres")
    cur = conn.cursor()
    query = """
        SELECT *
        FROM transaction
        WHERE c_id = %s;
    """
    cur.execute(query, (c_id,))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results
def getalltransitems(t_id):
    conn = psycopg2.connect("dbname=pos user=postgres password=postgres")
    cur = conn.cursor()
    query = """
    SELECT
    transaction_items.t_id,
    transaction_items.item_sku,
    inventoryitem.item_name,
    transaction_items.quantity
    FROM transaction_items
    INNER JOIN inventoryitem ON transaction_items.item_sku = inventoryitem.item_sku
    WHERE transaction_items.t_id = %s;
    """
    cur.execute(query,(t_id,))
    results = cur.fetchall()
    cur.close()
    conn.close()
    return results