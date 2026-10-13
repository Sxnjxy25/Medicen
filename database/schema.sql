CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) DEFAULT 'User',
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK(role IN ('ADMIN','STAFF')),
    phone VARCHAR(15),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS suppliers (
    id SERIAL PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100),
    address TEXT,
    gst_number VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS racks (
    id SERIAL PRIMARY KEY,
    rack_name VARCHAR(20),
    shelf_number INT,
    box_number INT,
    description TEXT
);

CREATE TABLE IF NOT EXISTS medicines (
    id SERIAL PRIMARY KEY,
    medicine_code VARCHAR(50) UNIQUE NOT NULL,
    qr_code VARCHAR(100) UNIQUE,
    barcode VARCHAR(100),
    medicine_name VARCHAR(150) NOT NULL,
    generic_name VARCHAR(150),
    manufacturer VARCHAR(100),
    company VARCHAR(100),
    category VARCHAR(100),
    unit VARCHAR(50) DEFAULT 'Tablet',
    purchase_price NUMERIC(10,2),
    selling_price NUMERIC(10,2),
    gst_percentage NUMERIC(5,2) DEFAULT 0.00,
    gst NUMERIC(5,2) DEFAULT 0.00,
    rack_id VARCHAR(50),
    minimum_stock INT DEFAULT 10,
    prescription_required BOOLEAN DEFAULT FALSE,
    active BOOLEAN DEFAULT TRUE,
    quantity INT DEFAULT 0,
    image_url TEXT,
    status BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS purchases (
    id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES suppliers(id),
    supplier VARCHAR(100),
    invoice_number VARCHAR(50),
    purchase_date DATE,
    items TEXT,
    total_amount NUMERIC(12,2),
    status VARCHAR(50) DEFAULT 'Delivered'
);

CREATE TABLE IF NOT EXISTS stock (
    id SERIAL PRIMARY KEY,
    medicine_id INT REFERENCES medicines(id),
    purchase_id INT REFERENCES purchases(id),
    batch_number VARCHAR(50),
    manufacture_date DATE,
    expiry_date DATE,
    quantity INT,
    remaining_quantity INT
);

CREATE TABLE IF NOT EXISTS customers (
    id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    phone VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS sales (
    id SERIAL PRIMARY KEY,
    invoice_number VARCHAR(50) UNIQUE NOT NULL,
    customer_id INT REFERENCES customers(id),
    customer_name VARCHAR(100),
    user_id INT REFERENCES users(id),
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal NUMERIC(12,2),
    total_amount NUMERIC(12,2),
    discount NUMERIC(10,2) DEFAULT 0.00,
    gst NUMERIC(10,2) DEFAULT 0.00,
    grand_total NUMERIC(12,2),
    payment_mode VARCHAR(20) DEFAULT 'Cash'
);

CREATE TABLE IF NOT EXISTS sale_items (
    id SERIAL PRIMARY KEY,
    sale_id INT REFERENCES sales(id) ON DELETE CASCADE,
    medicine_id INT REFERENCES medicines(id),
    stock_id INT REFERENCES stock(id),
    medicine_name VARCHAR(150),
    quantity INT NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    subtotal NUMERIC(12,2) NOT NULL
);

CREATE TABLE IF NOT EXISTS payments (
    id SERIAL PRIMARY KEY,
    sale_id INT REFERENCES sales(id) ON DELETE CASCADE,
    payment_type VARCHAR(30),
    amount NUMERIC(12,2),
    transaction_id VARCHAR(100),
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS notifications (
    id SERIAL PRIMARY KEY,
    medicine_id INT REFERENCES medicines(id),
    notification_type VARCHAR(50),
    message TEXT,
    status BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    action VARCHAR(200),
    table_name VARCHAR(100),
    record_id INT,
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);