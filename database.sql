-- Create the database
CREATE DATABASE supply_chain_management;
USE supply_chain_management;

-- Create Suppliers table
CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(50),
    country VARCHAR(50),
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    unit_price DECIMAL(10, 2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    reorder_level INT,
    supplier_id INT,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Create Purchase Orders table
CREATE TABLE purchase_orders (
    po_id INT PRIMARY KEY AUTO_INCREMENT,
    po_number VARCHAR(20) UNIQUE NOT NULL,
    supplier_id INT,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    status ENUM('Pending', 'Approved', 'Received', 'Cancelled') DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Create Purchase Order Items table
CREATE TABLE purchase_order_items (
    po_item_id INT PRIMARY KEY AUTO_INCREMENT,
    po_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (po_id) REFERENCES purchase_orders(po_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create Sales table
CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_contact VARCHAR(100),
    sale_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    payment_method ENUM('Cash', 'Card', 'Bank Transfer') DEFAULT 'Cash',
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Sale Items table
CREATE TABLE sale_items (
    sale_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create Inventory Transactions table
CREATE TABLE inventory_transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    transaction_type ENUM('Purchase', 'Sale', 'Adjustment') NOT NULL,
    reference_id INT,  -- PO_ID or Sale_ID
    quantity INT NOT NULL,
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- Create Users table
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    role ENUM('Admin', 'Manager', 'Staff') NOT NULL,
    status ENUM('Active', 'Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Contact Messages table
CREATE TABLE contact_messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    status ENUM('New', 'Read', 'Replied') DEFAULT 'New',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_supplier_status ON suppliers(status);
CREATE INDEX idx_product_status ON products(status);
CREATE INDEX idx_product_category ON products(category);
CREATE INDEX idx_po_status ON purchase_orders(status);
CREATE INDEX idx_sale_status ON sales(status);
CREATE INDEX idx_sale_date ON sales(sale_date);
CREATE INDEX idx_inventory_transaction_type ON inventory_transactions(transaction_type); 