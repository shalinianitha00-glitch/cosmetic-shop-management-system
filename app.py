from flask import Flask, render_template, request, redirect, session, flash
import mysql.connector
import re

app = Flask(__name__)
app.secret_key = "glowcart_secret_key"


# ---------- MYSQL CONNECTION ----------
def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="Shalini_07",
        database="glowcart"
    )


# ================= CUSTOMER SECTION =================

@app.route('/')
def home():
    return render_template("login.html")


# ---------- REGISTER ----------
@app.route('/register', methods=['POST'])
def register():
    name = request.form['name']
    email = request.form['email']
    phone = request.form['phone']
    password = request.form['password']
    confirm_password = request.form['confirm_password']

    phone_pattern = r'^[0-9]{10}$'
    strong_password_pattern = r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-\\\/\[\]=+;\'`~]).{8,}$'

    if not re.match(phone_pattern, phone):
        flash("❌ Phone number must be exactly 10 digits!", "error")
        return redirect('/')

    if not re.match(strong_password_pattern, password):
        flash("❌ Password must contain at least 8 characters, 1 uppercase letter, 1 number, and 1 special character!", "error")
        return redirect('/')

    if password != confirm_password:
        flash("❌ Password and Confirm Password do not match!", "error")
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "INSERT INTO customers (name, email, phone, password) VALUES (%s, %s, %s, %s)",
            (name, email, phone, password)
        )
        conn.commit()
        flash("✅ Registered successfully! Please login.", "success")
    except mysql.connector.Error:
        flash("❌ Email already exists! Try another email.", "error")

    cursor.close()
    conn.close()
    return redirect('/')


# ---------- CUSTOMER LOGIN ----------
@app.route('/customer_login', methods=['POST'])
def customer_login():
    email = request.form['email']
    password = request.form['password']

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT * FROM customers WHERE email=%s AND password=%s",
        (email, password)
    )
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if user:
        session.clear()
        session['user_id'] = user[0]
        session['user_name'] = user[1]
        return redirect('/customer_dashboard')
    else:
        flash("❌ Invalid customer email or password!", "error")
        return redirect('/')


# ---------- CUSTOMER DASHBOARD ----------
@app.route('/customer_dashboard')
def customer_dashboard():
    if 'user_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM products")
    products = cursor.fetchall()

    cursor.close()
    conn.close()

    last_order_id = session.get('last_order_id')

    return render_template(
    "customer_dashboard.html",
    products=products,
    last_order_id=last_order_id
)


# ---------- PRODUCTS PAGE ----------
@app.route('/products')
def products():
    if 'user_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM products")
    products = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("products.html", products=products)


# ---------- ADD TO CART ----------
@app.route('/add_to_cart/<int:product_id>', methods=['POST'])
def add_to_cart(product_id):
    if 'user_id' not in session:
        return redirect('/')

    quantity = int(request.form.get('quantity', 1))
    if quantity < 1:
        quantity = 1

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT stock FROM products WHERE id=%s", (product_id,))
    product = cursor.fetchone()

    cursor.close()
    conn.close()

    if not product:
        return redirect(request.referrer or '/customer_dashboard')

    stock = int(product.get('stock') or 0)

    if stock <= 0:
        flash("❌ This product is out of stock!", "error")
        return redirect(request.referrer or '/customer_dashboard')

    if quantity > stock:
        quantity = stock

    if 'cart' not in session or not isinstance(session['cart'], dict):
        session['cart'] = {}

    cart = session['cart']
    pid = str(product_id)

    if pid in cart:
        cart[pid] = int(cart[pid]) + quantity
        if cart[pid] > stock:
            cart[pid] = stock
    else:
        cart[pid] = quantity

    session['cart'] = cart
    session.modified = True

    flash("✅ Added to cart!", "success")
    return redirect(request.referrer or '/customer_dashboard')


# ---------- CART ----------
@app.route("/cart")
def cart():
    if 'user_id' not in session:
        return redirect('/')

    cart = session.get('cart', {})
    cart_items = []
    total_amount = 0.0

    if cart:
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        updated_cart = dict(cart)

        for product_id, quantity in cart.items():
            pid = int(product_id)
            qty = int(quantity)

            cursor.execute("SELECT id, name, price, stock FROM products WHERE id=%s", (pid,))
            product = cursor.fetchone()

            if not product:
                updated_cart.pop(str(pid), None)
                continue

            stock = int(product.get('stock') or 0)

            if stock <= 0:
                updated_cart.pop(str(pid), None)
                continue

            if qty > stock:
                qty = stock
                updated_cart[str(pid)] = qty

            subtotal = float(product['price']) * qty
            total_amount += subtotal

            cart_items.append({
                "id": product['id'],
                "name": product['name'],
                "price": float(product['price']),
                "quantity": qty,
                "subtotal": subtotal,
                "stock": stock
            })

        cursor.close()
        conn.close()

        session['cart'] = updated_cart
        session.modified = True

    return render_template("cart.html", cart_items=cart_items, total_amount=total_amount)


# ---------- CHECKOUT ----------
@app.route('/checkout')
def checkout():
    if 'user_id' not in session:
        return redirect('/')

    success = request.args.get('success')
    cart = session.get('cart', {})

    if success and not cart:
        return render_template("checkout.html", cart_items=[], total_amount=0, success=success)

    if not cart:
        return redirect('/cart')

    cart_items = []
    total_amount = 0.0

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    updated_cart = dict(cart)

    for product_id, quantity in cart.items():
        pid = int(product_id)
        qty = int(quantity)

        cursor.execute("SELECT name, price, stock FROM products WHERE id=%s", (pid,))
        product = cursor.fetchone()

        if not product:
            updated_cart.pop(str(pid), None)
            continue

        stock = int(product.get('stock') or 0)
        if stock <= 0:
            updated_cart.pop(str(pid), None)
            continue

        if qty > stock:
            qty = stock
            updated_cart[str(pid)] = qty

        subtotal = float(product['price']) * qty
        total_amount += subtotal

        cart_items.append({
            "name": product['name'],
            "quantity": qty,
            "subtotal": subtotal
        })

    cursor.close()
    conn.close()

    session['cart'] = updated_cart
    session.modified = True

    if not session.get('cart'):
        return redirect('/cart')

    return render_template("checkout.html", cart_items=cart_items, total_amount=total_amount, success=success)


# ---------- PLACE ORDER ----------
@app.route('/place_order', methods=['POST'])
def place_order():
    if 'user_id' not in session:
        return redirect('/')

    name = request.form['name']
    phone = request.form['phone']
    address = request.form['address']
    payment_mode = request.form['payment_mode']

    cart = session.get('cart', {})
    if not cart:
        return redirect('/cart')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    total_amount = 0.0
    items_to_update = []

    for product_id, quantity in cart.items():
        pid = int(product_id)
        qty = int(quantity)

        cursor.execute("SELECT price, stock FROM products WHERE id=%s", (pid,))
        product = cursor.fetchone()
        if not product:
            continue

        stock = int(product.get('stock') or 0)
        if stock <= 0:
            continue

        if qty > stock:
            qty = stock

        if qty <= 0:
            continue

        total_amount += float(product['price']) * qty
        items_to_update.append((qty, pid))

    cursor.close()

    if total_amount <= 0 or not items_to_update:
        conn.close()
        return redirect('/cart')

    cursor2 = conn.cursor()
    cursor2.execute("""
    INSERT INTO orders (customer_id, customer_name, phone, address, payment_mode, total_amount)
    VALUES (%s, %s, %s, %s, %s, %s)
""", (session['user_id'], name, phone, address, payment_mode, total_amount))
    order_id = cursor2.lastrowid
    session['last_order_id'] = order_id
    cursor3 = conn.cursor()
    for qty, pid in items_to_update:
        cursor3.execute(
            "UPDATE products SET stock = stock - %s WHERE id=%s AND stock >= %s",
            (qty, pid, qty)
        )

    conn.commit()

    cursor2.close()
    cursor3.close()
    conn.close()

    session.pop('cart', None)

    return redirect('/checkout?success=1')


# ---------- CUSTOMER ORDERS ----------
@app.route('/orders')
def orders():
    if 'user_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM orders WHERE customer_id=%s ORDER BY id DESC",
        (session['user_id'],)
    )
    orders = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("orders.html", orders=orders)


# ---------- PROFILE ----------
@app.route('/profile')
def profile():
    if 'user_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM customers WHERE id=%s", (session['user_id'],))
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template("profile.html", user=user)


# ---------- LOGOUT ----------
@app.route('/logout')
def logout():
    session.clear()
    return redirect('/')


# ================= ADMIN SECTION =================
@app.route('/admin_login', methods=['POST'])
def admin_login():
    email = request.form['email']
    password = request.form['password']

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute(
        "SELECT * FROM admins WHERE email=%s AND password=%s",
        (email, password)
    )
    admin = cursor.fetchone()

    cursor.close()
    conn.close()

    if admin:
        session.clear()
        session['admin_id'] = admin[0]
        session['admin_email'] = admin[1]
        return redirect('/admin_dashboard')
        
    else:
        flash("❌ Invalid admin email or password!", "error")
        return redirect('/?tab=admin')


@app.route('/admin_dashboard')
def admin_dashboard():
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Existing stats
    cursor.execute("SELECT COUNT(*) AS total_products FROM products")
    total_products = cursor.fetchone()['total_products']

    cursor.execute("SELECT COUNT(*) AS total_orders FROM orders")
    total_orders = cursor.fetchone()['total_orders']

    cursor.execute("SELECT COUNT(*) AS total_customers FROM customers")
    total_customers = cursor.fetchone()['total_customers']

    cursor.execute("SELECT SUM(total_amount) AS total_revenue FROM orders")
    revenue_data = cursor.fetchone()
    total_revenue = revenue_data['total_revenue'] or 0

    # ✅ NEW: Pending Orders
    cursor.execute("SELECT COUNT(*) AS pending_orders FROM orders WHERE status = 'Placed'")
    pending_orders = cursor.fetchone()['pending_orders']

    # ✅ NEW: Cancelled Orders
    cursor.execute("SELECT COUNT(*) AS cancelled_orders FROM orders WHERE status = 'Cancelled'")
    cancelled_orders = cursor.fetchone()['cancelled_orders']

    cursor.close()
    conn.close()

    return render_template(
        'admin_dashboard.html',
        total_products=total_products,
        total_orders=total_orders,
        total_customers=total_customers,
        total_revenue=total_revenue,
        pending_orders=pending_orders,
        cancelled_orders=cancelled_orders
    )


@app.route('/admin_products')
def admin_products():
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM products")
    products = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("admin_products.html", products=products)


@app.route('/add_product', methods=['GET', 'POST'])
def add_product():
    if 'admin_id' not in session:
        return redirect('/')

    if request.method == 'POST':
        name = request.form['name']
        price = request.form['price']
        description = request.form['description']
        image = request.form['image']
        stock = int(request.form.get('stock', 0))

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO products (name, price, description, image, stock)
            VALUES (%s, %s, %s, %s, %s)
        """, (name, price, description, image, stock))

        conn.commit()
        cursor.close()
        conn.close()

        flash("✅ Product added successfully!", "success")
        return redirect('/admin_products')

    return render_template("add_product.html")


@app.route('/edit_product/<int:id>', methods=['GET', 'POST'])
def edit_product(id):
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        name = request.form['name']
        price = request.form['price']
        description = request.form['description']
        image = request.form['image']
        stock = int(request.form.get('stock', 0))

        cursor2 = conn.cursor()
        cursor2.execute("""
            UPDATE products
            SET name=%s, price=%s, description=%s, image=%s, stock=%s
            WHERE id=%s
        """, (name, price, description, image, stock, id))

        conn.commit()
        cursor2.close()
        cursor.close()
        conn.close()

        flash("✅ Product updated successfully!", "success")
        return redirect('/admin_products')

    cursor.execute("SELECT * FROM products WHERE id=%s", (id,))
    product = cursor.fetchone()

    cursor.close()
    conn.close()

    return render_template("edit_product.html", product=product)


@app.route('/delete_product/<int:id>')
def delete_product(id):
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("DELETE FROM products WHERE id=%s", (id,))
    conn.commit()
    cursor.close()
    conn.close()

    flash("✅ Product deleted!", "success")
    return redirect('/admin_products')


@app.route('/admin_orders')
def admin_orders():
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM orders ORDER BY order_date DESC")
    orders = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("admin_orders.html", orders=orders)


@app.route('/update_order_status/<int:order_id>', methods=['POST'])
def update_order_status(order_id):
    if 'admin_id' not in session:
        return redirect('/')

    new_status = request.form['status']

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("UPDATE orders SET status=%s WHERE id=%s", (new_status, order_id))
    conn.commit()

    cursor.close()
    conn.close()

    flash("✅ Order status updated!", "success")
    return redirect('/admin_orders')


@app.route('/increase_qty/<int:product_id>')
def increase_qty(product_id):
    if 'user_id' not in session:
        return redirect('/')

    cart = session.get('cart', {})
    pid = str(product_id)

    if pid not in cart:
        return redirect('/cart')

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT stock FROM products WHERE id=%s", (product_id,))
    product = cursor.fetchone()
    cursor.close()
    conn.close()

    stock = int(product.get('stock') or 0) if product else 0

    if int(cart[pid]) < stock:
        cart[pid] = int(cart[pid]) + 1

    session['cart'] = cart
    session.modified = True
    return redirect('/cart')


@app.route('/decrease_qty/<int:product_id>')
def decrease_qty(product_id):
    if 'user_id' not in session:
        return redirect('/')

    cart = session.get('cart', {})
    pid = str(product_id)

    if pid in cart:
        cart[pid] = int(cart[pid]) - 1
        if cart[pid] <= 0:
            cart.pop(pid, None)

    session['cart'] = cart
    session.modified = True
    return redirect('/cart')


@app.route('/remove_from_cart/<int:product_id>')
def remove_from_cart(product_id):
    if 'user_id' not in session:
        return redirect('/')

    cart = session.get('cart', {})
    cart.pop(str(product_id), None)

    session['cart'] = cart
    session.modified = True
    return redirect('/cart')


@app.route('/admin_stock_increase/<int:product_id>')
def admin_stock_increase(product_id):
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE products SET stock = stock + 1 WHERE id=%s", (product_id,))
    conn.commit()
    cursor.close()
    conn.close()

    flash("✅ Stock increased!", "success")
    return redirect('/admin_products')


@app.route('/admin_stock_decrease/<int:product_id>')
def admin_stock_decrease(product_id):
    if 'admin_id' not in session:
        return redirect('/')

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute("UPDATE products SET stock = GREATEST(stock - 1, 0) WHERE id=%s", (product_id,))
    conn.commit()
    cursor.close()
    conn.close()

    flash("✅ Stock decreased!", "success")
    return redirect('/admin_products')

@app.route('/view_customers')
def view_customers():
    search = request.args.get('search', '').strip()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if search:
        cursor.execute("""
            SELECT * FROM customers
            WHERE name LIKE %s OR email LIKE %s
        """, ('%' + search + '%', '%' + search + '%'))
    else:
        cursor.execute("SELECT * FROM customers")

    customers = cursor.fetchall()
    conn.close()
    return render_template("view_customers.html", customers=customers)

@app.route('/register_page')
def register_page():
    return render_template('register.html')
    
@app.route('/submit_feedback', methods=['POST'])
def submit_feedback():
    if 'user_id' not in session:
        return redirect('/')

    user_id = session['user_id']
    order_id = request.form.get('order_id')
    rating = request.form.get('rating')
    comment = request.form.get('comment')

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO feedback (user_id, order_id, rating, comment)
        VALUES (%s, %s, %s, %s)
    """, (user_id, order_id, rating, comment))

    conn.commit()
    cursor.close()
    conn.close()

    return redirect('/customer_dashboard')
@app.route('/admin_feedback')
def admin_feedback():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT f.*, c.name AS user_name
        FROM feedback f
        JOIN customers c ON f.user_id = c.id
        ORDER BY f.id DESC
    """)

    feedbacks = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template("admin_feedback.html", feedbacks=feedbacks)
if __name__ == "__main__":
    app.run(debug=True)