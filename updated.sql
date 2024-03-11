DROP INDEX IF EXISTS idx_users_name;
DROP INDEX IF EXISTS idx_users_login_id;
DROP INDEX IF EXISTS idx_users_phone;
DROP INDEX IF EXISTS idx_location_user_id;
DROP INDEX IF EXISTS idx_location_postalcode;
DROP INDEX IF EXISTS idx_vendors_name;
DROP INDEX IF EXISTS idx_items_name;
DROP INDEX IF EXISTS idx_items_vendor_id;
DROP INDEX IF EXISTS idx_items_price;
DROP INDEX IF EXISTS idx_sellers_user_id;
DROP INDEX IF EXISTS idx_sellers_state_taxid;
DROP INDEX IF EXISTS idx_sellers_national_taxid;
DROP INDEX IF EXISTS idx_orders_user_id;
DROP INDEX IF EXISTS idx_orders_shipping_id;
DROP INDEX IF EXISTS idx_orders_date;
DROP INDEX IF EXISTS idx_customerfeedback_item_id;
DROP INDEX IF EXISTS idx_customerfeedback_user_id;
DROP VIEW IF EXISTS OrderDetails;
DROP VIEW IF EXISTS MonthlySales;
DROP VIEW IF EXISTS AverageRating;
DROP VIEW IF EXISTS TotalRevenue;
DROP VIEW IF EXISTS ActiveUsersView;


DROP VIEW IF EXISTS "AvailableItems";
PRAGMA foreign_keys=OFF;

BEGIN TRANSACTION;


DROP TABLE IF EXISTS "Users";
DROP TABLE IF EXISTS "Location";
DROP TABLE IF EXISTS "OrderHistory";
DROP TABLE IF EXISTS "Customer_Feedback";
DROP TABLE IF EXISTS "Sellers";
DROP TABLE IF EXISTS "Sold_By";
DROP TABLE IF EXISTS "Business";
DROP TABLE IF EXISTS "Items";
DROP TABLE IF EXISTS "Warehouses";
DROP TABLE IF EXISTS "Vendors";
DROP TABLE IF EXISTS "ItemsWarehouses";
DROP TABLE IF EXISTS "Orders";
DROP TABLE IF EXISTS "PaymentMethods";
DROP TABLE IF EXISTS "ItemsOrders";
DROP TABLE IF EXISTS "Wallet";
DROP TABLE IF EXISTS "Invoice";
DROP TABLE IF EXISTS "Payment";
DROP TABLE IF EXISTS "CreditCard";
DROP TABLE IF EXISTS "Shipping";
DROP TABLE IF EXISTS "ShippingMethods";


DROP VIEW IF EXISTS "AvailableItems";
DROP VIEW IF EXISTS "PrimeMembers";
DROP VIEW IF EXISTS "PublicSellers";

COMMIT;





CREATE TABLE "Users" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "name" TEXT NOT NULL,
    "login_id" TEXT NOT NULL UNIQUE,
    "hashed_password" TEXT NOT NULL,
    "phone" TEXT NOT NULL,
    "role" TEXT NOT NULL CHECK("role" IN ('buyer', 'seller', 'both')),
    "deleted" INTEGER DEFAULT 0,
    "prime_membership" INTEGER DEFAULT 0
);


CREATE TABLE "Location" (
    "user_id" INTEGER,
    "state" TEXT,
    "city" TEXT,
    "postalcode" TEXT NOT NULL UNIQUE, 
    "street" TEXT,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);
CREATE VIEW PublicSellers AS
SELECT Users.name AS seller_name, Business.name AS business_name, Users.phone AS phone_no
FROM Users
JOIN Sellers ON Users.id = Sellers.user_id
JOIN Business ON Sellers.id = Business.owner_id;


CREATE TABLE "Vendors" (
    "vendor_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "vendor_name" TEXT NOT NULL
);


CREATE TABLE "Items" (
    "item_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "item_price" REAL NOT NULL,
    "item_name" TEXT NOT NULL,
    "quantity" INTEGER DEFAULT 0,
    "condition" TEXT DEFAULT 'ok' CHECK("condition" IN ('ok', 'bad', 'good')),
    "vendor_id" INTEGER,
    FOREIGN KEY("vendor_id") REFERENCES "Vendors"("vendor_id") ON DELETE SET NULL
);


CREATE VIEW AvailableItems AS
SELECT *
FROM "Items"
WHERE "quantity" > 0;

CREATE VIEW "PrimeMembers" AS
SELECT * FROM "Users" WHERE "prime_membership" =1;


CREATE TABLE "Sellers" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER,
    "state_taxID" TEXT, 
    "national_taxID" TEXT NOT NULL,
    "account_no" TEXT NOT NULL,
    "IFSC_no" TEXT NOT NULL,
    "bank_branch" TEXT,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);


CREATE TABLE "Sold_By" (
    "item_id" INTEGER,
    "seller_id" INTEGER,
    PRIMARY KEY("item_id", "seller_id"),
    FOREIGN KEY("item_id") REFERENCES "Items"("item_id") ON DELETE CASCADE,
    FOREIGN KEY("seller_id") REFERENCES "Sellers"("id") ON DELETE CASCADE
);


CREATE TABLE "Business" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "owner_id" INTEGER,
    "name" TEXT NOT NULL,
    "phone_no" TEXT,
    FOREIGN KEY("owner_id") REFERENCES "Sellers"("id") ON DELETE CASCADE
);


CREATE TABLE "Orders" (
    "order_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "shipping_id" INTEGER NOT NULL,
    "is_cancelled" INTEGER DEFAULT 0, 
    "date_of_order" TEXT DEFAULT CURRENT_TIMESTAMP,
    "order_summary" TEXT,
    "grand_total" REAL NOT NULL DEFAULT 0.0,
    "payment_method" INTEGER,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
    FOREIGN KEY("shipping_id") REFERENCES "Shipping"("shipping_id"),
    FOREIGN KEY("payment_method") REFERENCES "PaymentMethods"("method_id")
);


CREATE TABLE "OrderHistory" (
    "history_id" INTEGER PRIMARY KEY AUTOINCREMENT,
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


CREATE TABLE "PaymentMethods" (
    "method_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "method_name" TEXT NOT NULL UNIQUE
);


CREATE TABLE "ShippingMethods" (
    "method_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "method_name" TEXT NOT NULL UNIQUE
);


CREATE TABLE "Shipping" (
    "shipping_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "shipping_method" INTEGER NOT NULL,
    "street_name" TEXT,
    "city_name" TEXT,
    "zip_code" TEXT, 
    FOREIGN KEY("shipping_method") REFERENCES "ShippingMethods"("method_id") ON DELETE CASCADE
);


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
    FOREIGN KEY("item_id") REFERENCES Items(item_id) ON DELETE CASCADE
);
DROP TABLE IF EXISTS "ItemsOrders";
CREATE TABLE "ItemsOrders" (
    "item_id" INTEGER ,
    "order_id" INTEGER
);


CREATE TABLE "Invoice" (
    "invoice_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "order_id" INTEGER NOT NULL,
    "seller_id" INTEGER NOT NULL,
    FOREIGN KEY("order_id") REFERENCES "Orders"("order_id"),
    FOREIGN KEY("seller_id") REFERENCES "Sellers"("id")
);


CREATE TABLE "Payment" (
    "payment_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "invoice_id" INTEGER NOT NULL,
    "payment_method" INTEGER NOT NULL,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
    FOREIGN KEY("invoice_id") REFERENCES "Invoice"("invoice_id"),
    FOREIGN KEY("payment_method") REFERENCES "PaymentMethods"("method_id")
);


CREATE TABLE "CreditCard" (
    "card_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type" TEXT NOT NULL CHECK("type" IN ('credit', 'debit')),
    "security_code" TEXT NOT NULL CHECK(LENGTH(security_code) = 3 OR LENGTH(security_code) = 4), 
    "expiration_date" TEXT NOT NULL, 
    "card_holder_name" TEXT NOT NULL,
    "wallet_id" INTEGER NOT NULL,
    FOREIGN KEY("wallet_id") REFERENCES "Wallet"("wallet_id") ON DELETE CASCADE
);


CREATE TABLE "Warehouses" (
    "warehouse_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "warehouse_name" TEXT NOT NULL,
    "street_name" TEXT,
    "city_name" TEXT,
    "zip_code" TEXT 
);

-- Create ItemsWarehouses table
CREATE TABLE "ItemsWarehouses" (
    "item_id" INTEGER,
    "warehouse_id" INTEGER,
    PRIMARY KEY("item_id", "warehouse_id"),
    FOREIGN KEY("item_id") REFERENCES "Items"("item_id") ON DELETE CASCADE,
    FOREIGN KEY("warehouse_id") REFERENCES "Warehouses"("warehouse_id") ON DELETE CASCADE
);



CREATE TRIGGER AddOrderHistory
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO OrderHistory(order_id, user_id, amount, status)
    VALUES (NEW.order_id, NEW.user_id, NEW.grand_total, 'pending');
END;


CREATE TRIGGER RemoveItemWhenZero
AFTER UPDATE ON Items
FOR EACH ROW
WHEN NEW.quantity = 0
BEGIN
    DELETE FROM Items WHERE item_id = NEW.item_id;
END;


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

CREATE TRIGGER MoveCartItemsToOrder AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO ItemsOrders (order_id, item_id)
    SELECT NEW.order_id, item_id FROM ShoppingCart
    JOIN ItemsInCart ON ShoppingCart.cart_id = ItemsInCart.cart_id
    WHERE ShoppingCart.user_id = NEW.user_id;
END;

CREATE TRIGGER AddToOrderHistory AFTER UPDATE ON Orders
WHEN NEW.is_delivered = TRUE
BEGIN
    INSERT INTO OrderHistory (order_id, user_id, status) VALUES (NEW.order_id, NEW.user_id, 'Delivered');
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

CREATE VIEW OrderDetails AS
SELECT Orders.order_id, Users.name AS user_name, Items.item_name, Items.item_price
FROM Orders
JOIN Users ON Orders.user_id = Users.id
JOIN ItemsOrders ON Orders.order_id = ItemsOrders.order_id
JOIN Items ON ItemsOrders.item_id = Items.item_id;
CREATE VIEW MonthlySales AS
SELECT strftime('%Y-%m', Orders.date_of_order) AS month, SUM(Orders.grand_total) AS total_sales
FROM Orders
GROUP BY month;
CREATE VIEW AverageRating AS
SELECT item_id, AVG(rating) AS avg_rating
FROM Customer_Feedback
GROUP BY item_id;
CREATE VIEW TotalRevenue AS
SELECT strftime('%Y-%m', Orders.date_of_order) AS month, SUM(Orders.grand_total) AS total_revenue
FROM Orders
GROUP BY month;
CREATE VIEW ActiveUsersView AS
SELECT *
FROM Users
WHERE deleted = FALSE;
