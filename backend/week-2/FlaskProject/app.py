from flask import Flask, render_template, request, jsonify, redirect, session
import psycopg2

app = Flask(__name__)
app.secret_key = 'nBtG1jKBX5HweygH'  
app.jinja_env.globals.update(zip=zip)


@app.route("/", methods=["GET", "POST"])
def login():
    if request.method == "POST":
        session['DB_USER'] = request.form['db_user']
        session['DB_PASSWORD'] = request.form['db_password']
        return redirect("/products")
    return render_template("login.html")


@app.route("/products", methods=["GET", "POST"])
def index():
    db_user = session.get('DB_USER')
    db_password = session.get('DB_PASSWORD')
    if not db_user or not db_password:
        return redirect("/")

    conn = psycopg2.connect(dbname='pos', user=db_user, password=db_password)
    cursor = conn.cursor()

    search_id = request.form.get("search_id") if request.method == "POST" else None

    if search_id:
        query = "SELECT * FROM inventoryitem WHERE item_sku = %s;"
        cursor.execute(query, (search_id,))
    else:
        cursor.execute("SELECT * FROM inventoryitem ORDER BY item_sku ASC;")
    rows = cursor.fetchall()
    columns = [desc[0] for desc in cursor.description]

    cursor.close()
    conn.close()

    return render_template("products_editor.html", rows=rows, columns=columns)


@app.route("/update", methods=["POST"])
def update():
    db_user = session.get('DB_USER')
    db_password = session.get('DB_PASSWORD')
    if not db_user or not db_password:
        return redirect("/")

    data = request.json
    row_id = data["id"]
    column = data["column"]
    value = data["value"]

    conn = psycopg2.connect(dbname='pos', user=db_user, password=db_password)
    cursor = conn.cursor()

    query = f"UPDATE inventoryitem SET {column} = %s WHERE item_sku = %s;"
    cursor.execute(query, (value, row_id))
    conn.commit()

    cursor.close()
    conn.close()

    return jsonify({"status": "success"})


@app.route("/add", methods=["POST"])
def add_row():
    db_user = session.get('DB_USER')
    db_password = session.get('DB_PASSWORD')
    if not db_user or not db_password:
        return redirect("/")

    row_data = {key: value for key, value in request.form.items()}

    conn = psycopg2.connect(dbname='pos', user=db_user, password=db_password)
    cursor = conn.cursor()

    columns = ", ".join(row_data.keys())
    placeholders = ", ".join(["%s"] * len(row_data))
    query = f"INSERT INTO inventoryitem ({columns}) VALUES ({placeholders})"
    cursor.execute(query, list(row_data.values()))

    conn.commit()
    cursor.close()
    conn.close()

    return redirect("/products")


@app.route("/delete", methods=["POST"])
def delete_row():
    db_user = session.get('DB_USER')
    db_password = session.get('DB_PASSWORD')
    if not db_user or not db_password:
        return redirect("/")

    row_id = request.form.get("id")

    conn = psycopg2.connect(dbname='pos', user=db_user, password=db_password)
    cursor = conn.cursor()

    query = "DELETE FROM inventoryitem WHERE item_sku = %s"
    cursor.execute(query, (row_id,))

    conn.commit()
    cursor.close()
    conn.close()

    return redirect("/products")

if __name__ == "__main__":
    app.run(debug=True)