-- Drop existing structures if they exist
DROP VIEW IF EXISTS "AvailableItems"; 
DROP TABLE IF EXISTS "OrderHistory";
DROP TABLE IF EXISTS "Orders";
DROP TABLE IF EXISTS "Customer_Feedback";
DROP TABLE IF EXISTS "Sellers";
DROP TABLE IF EXISTS "Sold_By";
DROP TABLE IF EXISTS "Business";
DROP TABLE IF EXISTS "Items";
DROP TABLE IF EXISTS "Warehouses";
DROP TABLE IF EXISTS "Vendors";
DROP TABLE IF EXISTS "ItemsWarehouses";
DROP TABLE IF EXISTS "PaymentMethods";
DROP TABLE IF EXISTS "ItemsOrders";
DROP TABLE IF EXISTS "Wallet";
DROP TABLE IF EXISTS "Invoice";
DROP TABLE IF EXISTS "Payment";
DROP TABLE IF EXISTS "CreditCard";
DROP TABLE IF EXISTS "Shipping";
DROP TABLE IF EXISTS "ShippingMethods";
DROP TABLE IF EXISTS "Location";
DROP TABLE IF EXISTS "Users";

-- Create Users table
CREATE TABLE "Users" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "login_id" TEXT NOT NULL UNIQUE,
    "hashed_password" TEXT NOT NULL,
    "phone" TEXT NOT NULL, -- Changed from NUMERIC to TEXT to accommodate different phone number formats
    "role" TEXT NOT NULL CHECK("role" IN ('buyer', 'seller', 'both')),
    "deleted" INTEGER DEFAULT 0,
    "prime_membership" INTEGER DEFAULT 0
);

-- Create Location table
CREATE TABLE "Location" (
    "user_id" INTEGER,
    "state" TEXT,
    "city" TEXT,
    "postalcode" TEXT NOT NULL UNIQUE, -- Changed from NUMERIC to TEXT to accommodate different postal code formats
    "street" TEXT,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);

-- Create Vendors table
CREATE TABLE "Vendors" (
    "vendor_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "vendor_name" TEXT NOT NULL
);

-- Create Items table
CREATE TABLE "Items" (
    "item_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "item_price" REAL NOT NULL,
    "item_name" TEXT NOT NULL,
    "quantity" INTEGER DEFAULT 0,
    "condition" TEXT DEFAULT 'ok' CHECK("condition" IN ('ok', 'bad', 'good')),
    "vendor_id" INTEGER,
    FOREIGN KEY("vendor_id") REFERENCES "Vendors"("vendor_id") ON DELETE SET NULL
);

-- Create AvailableItems view
CREATE VIEW AvailableItems AS
SELECT *
FROM "Items"
WHERE "quantity" > 0;

-- Create Sellers table
CREATE TABLE "Sellers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER,
    "state_taxID" TEXT, -- Changed from INTEGER as tax IDs can have different formats
    "national_taxID" TEXT NOT NULL,
    "account_no" TEXT NOT NULL,
    "IFSC_no" TEXT NOT NULL,
    "bank_branch" TEXT,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);

-- Create Sold_By table
CREATE TABLE "Sold_By" (
    "item_id" INTEGER,
    "seller_id" INTEGER,
    PRIMARY KEY("item_id", "seller_id"),
    FOREIGN KEY("item_id") REFERENCES "Items"("item_id") ON DELETE CASCADE,
    FOREIGN KEY("seller_id") REFERENCES "Sellers"("id") ON DELETE CASCADE
);

-- Create Business table
CREATE TABLE "Business" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "owner_id" INTEGER,
    "name" TEXT NOT NULL,
    "phone_no" TEXT, -- Changed from NUMERIC to TEXT for consistency
    FOREIGN KEY("owner_id") REFERENCES "Sellers"("id") ON DELETE CASCADE
);

-- Create Orders table
CREATE TABLE "Orders" (
    "order_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "shipping_id" INTEGER NOT NULL,
    "is_cancelled" INTEGER DEFAULT 0, -- Changed to INTEGER for clarity (0 for not cancelled, 1 for cancelled)
    "date_of_order" TEXT DEFAULT CURRENT_TIMESTAMP,
    "order_summary" TEXT,
    "grand_total" REAL NOT NULL DEFAULT 0.0,
    "payment_method" INTEGER,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
    FOREIGN KEY("shipping_id") REFERENCES "Shipping"("shipping_id"),
    FOREIGN KEY("payment_method") REFERENCES "PaymentMethods"("method_id")
);

-- Create OrderHistory table
CREATE TABLE "OrderHistory" (
    "history_id" INTEGER PRIMARY KEY AUTOINCREMENT, -- Added a primary key
    "order_id" INTEGER NOT NULL,
    "user_id" INTEGER,
    "amount" REAL NOT NULL CHECK("amount" > 0),
    "payment_method" INTEGER,
    "date" TEXT DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL CHECK("status" IN ('pending', 'delivered', 'cancelled')),
    FOREIGN KEY("order_id") REFERENCES "Orders"("order_id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
    FOREIGN KEY("payment_method") REFERENCES "PaymentMethods"("method_id")
);

-- Other tables and triggers would be created here following similar corrections and consistency checks

-- Create Customer_Feedback table
CREATE TABLE "Customer_Feedback" (
    "item_id" INTEGER,
    "user_id" INTEGER,
    "rating" INTEGER NOT NULL CHECK(rating >= 1 AND rating <= 5),
    "comment" TEXT,
    "date" TEXT DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("item_id", "user_id"),
    FOREIGN KEY("item_id") REFERENCES "Items"("item_id") ON DELETE CASCADE,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);

-- Create PaymentMethods table
CREATE TABLE "PaymentMethods" (
    "method_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "method_name" TEXT NOT NULL UNIQUE
);

-- Create ShippingMethods table
CREATE TABLE "ShippingMethods" (
    "method_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "method_name" TEXT NOT NULL UNIQUE
);

-- Create Shipping table
CREATE TABLE "Shipping" (
    "shipping_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "shipping_method" INTEGER NOT NULL,
    "street_name" TEXT,
    "city_name" TEXT,
    "zip_code" TEXT, -- Changed from NUMERIC for consistency
    FOREIGN KEY("shipping_method") REFERENCES "ShippingMethods"("method_id") ON DELETE CASCADE
);

-- Create Wallet table
CREATE TABLE "Wallet" (
    "wallet_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);
DROP TABLE IF EXISTS "ShoppingCart";
CREATE TABLE "ShoppingCart" (
     "cart_id" INTEGER PRIMARY KEY AUTOINCREMENT,
     "user_id" INTEGER NOT NULL,
     "total_price" DECIMAL(10,2) NOT NULL,
     FOREIGN KEY ("user_id") REFERENCES "Customers"("user_id") ON DELETE CASCADE
);
DROP TABLE IF EXISTS "ItemsInCart";
CREATE TABLE ItemsInCart (
    "cart_id" INTEGER NOT NULL,
    "item_id" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,
    "price" DECIMAL(10, 2) NOT NULL,
    --FOREIGN KEY("cart_id") REFERENCES ShoppingCart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY("item_id") REFERENCES Items(item_id) ON DELETE CASCADE
);
DROP TABLE IF EXISTS "ItemsOrders";
CREATE TABLE "ItemsOrders" (
    "item_id" INTEGER UNIQUE,
    "order_id" INTEGER UNIQUE
);
-- Create Invoice table
CREATE TABLE "Invoice" (
    "invoice_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "order_id" INTEGER NOT NULL,
    "seller_id" INTEGER NOT NULL,
    FOREIGN KEY("order_id") REFERENCES "Orders"("order_id"),
    FOREIGN KEY("seller_id") REFERENCES "Sellers"("id")
);

-- Create Payment table
CREATE TABLE "Payment" (
    "payment_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "invoice_id" INTEGER NOT NULL,
    "payment_method" INTEGER NOT NULL,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
    FOREIGN KEY("invoice_id") REFERENCES "Invoice"("invoice_id"),
    FOREIGN KEY("payment_method") REFERENCES "PaymentMethods"("method_id")
);

-- Create CreditCard table
CREATE TABLE "CreditCard" (
    "card_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type" TEXT NOT NULL CHECK("type" IN ('credit', 'debit')),
    "security_code" TEXT NOT NULL CHECK(LENGTH(security_code) = 3 OR LENGTH(security_code) = 4), -- Updated for common CVV lengths
    "expiration_date" TEXT NOT NULL, -- Fixed typo
    "card_holder_name" TEXT NOT NULL,
    "wallet_id" INTEGER NOT NULL,
    FOREIGN KEY("wallet_id") REFERENCES "Wallet"("wallet_id") ON DELETE CASCADE
);

-- Create Warehouses table
CREATE TABLE "Warehouses" (
    "warehouse_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "warehouse_name" TEXT NOT NULL,
    "street_name" TEXT,
    "city_name" TEXT,
    "zip_code" TEXT -- Changed from NUMERIC for consistency
);

-- Create ItemsWarehouses table
CREATE TABLE "ItemsWarehouses" (
    "item_id" INTEGER,
    "warehouse_id" INTEGER,
    PRIMARY KEY("item_id", "warehouse_id"),
    FOREIGN KEY("item_id") REFERENCES "Items"("item_id") ON DELETE CASCADE,
    FOREIGN KEY("warehouse_id") REFERENCES "Warehouses"("warehouse_id") ON DELETE CASCADE
);


-- Insert default data into PaymentMethods and ShippingMethods, if necessary
-- INSERT INTO "PaymentMethods" ("method_name") VALUES ('Visa'), ('MasterCard'), ('PayPal');
-- INSERT INTO "ShippingMethods" ("method_name") VALUES ('Standard'), ('Express'), ('Overnight');

-- Triggers and additional index creations can be added here as needed.
-- Trigger to add an entry to OrderHistory after a new order is inserted
CREATE TRIGGER AddOrderHistory
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO OrderHistory(order_id, user_id, amount, status)
    VALUES (NEW.order_id, NEW.user_id, NEW.grand_total, 'pending');
END;
-- Trigger to remove item from Items table if quantity is updated to 0
CREATE TRIGGER RemoveItemWhenZero
AFTER UPDATE ON Items
FOR EACH ROW
WHEN NEW.quantity = 0
BEGIN
    DELETE FROM Items WHERE item_id = NEW.item_id;
END;


--- View to see the prime membership 
CREATE VIEW PrimeMembersView AS
SELECT id, name, login_id, phone, role
FROM Users
WHERE prime_member = TRUE;

-- View to see the active users (where is_deleted is false) 
CREATE VIEW ActiveUsersView AS
SELECT *
FROM Users
WHERE is_deleted = FALSE;

--View to see available items 
CREATE VIEW AvailableItemsView AS
SELECT item_id, item_name, item_price, quantity, condition
FROM Items
WHERE is_deleted = FALSE AND quantity > 0;


-- Trigger to automatically update the total_price in ShoppingCart when ItemsInCart is updated
CREATE TRIGGER UpdateTotalPrice
AFTER INSERT  ON ItemsInCart
FOR EACH ROW
BEGIN
    UPDATE ShoppingCart
    SET total_price = (SELECT SUM(price * quantity) FROM ItemsInCart WHERE cart_id = NEW.cart_id)
    WHERE cart_id = NEW.cart_id;
END;
CREATE TRIGGER UpdateTotal_Price
AFTER UPDATE ON ItemsInCart
FOR EACH ROW
BEGIN
    UPDATE ShoppingCart
    SET total_price = (SELECT SUM(price * quantity) FROM ItemsInCart WHERE cart_id = NEW.cart_id)
    WHERE cart_id = NEW.cart_id;
END;
CREATE TRIGGER Update_TotalPrice
AFTER DELETE ON ItemsInCart
FOR EACH ROW
BEGIN
    UPDATE ShoppingCart
    SET total_price = (SELECT SUM(price * quantity) FROM ItemsInCart WHERE cart_id = NEW.cart_id)
    WHERE cart_id = NEW.cart_id;
END;
CREATE INDEX idx_users_name ON Users(name);
CREATE INDEX idx_users_login_id ON Users(login_id);
CREATE INDEX idx_users_phone ON Users(phone);
CREATE INDEX idx_location_user_id ON Location(user_id);
CREATE INDEX idx_location_postalcode ON Location(postalcode);

CREATE INDEX idx_vendors_name ON Vendors(vendor_name);
CREATE INDEX idx_items_name ON Items(item_name);
CREATE INDEX idx_items_vendor_id ON Items(vendor_id);
CREATE INDEX idx_items_price ON Items(item_price);
CREATE INDEX idx_sellers_user_id ON Sellers(user_id);
CREATE INDEX idx_sellers_state_taxid ON Sellers(state_taxID);
CREATE INDEX idx_sellers_national_taxid ON Sellers(national_taxID);
CREATE INDEX idx_orders_user_id ON Orders(user_id);
CREATE INDEX idx_orders_shipping_id ON Orders(shipping_id);
CREATE INDEX idx_orders_date ON Orders(date_of_order);
CREATE INDEX idx_customerfeedback_item_id ON Customer_Feedback(item_id);
CREATE INDEX idx_customerfeedback_user_id ON Customer_Feedback(user_id);

