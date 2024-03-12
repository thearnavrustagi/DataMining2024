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
    "prime_membership" INTEGER DEFAULT 0,
    "location_id" INTEGER NOT NULL
);


CREATE TABLE "Location" (
    "id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "state" TEXT NOT NULL,
    "city" TEXT NOT NULL,
    "postalcode" TEXT NOT NULL UNIQUE, 
    "street" TEXT NOT NULL
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
    "order_id" INTEGER,
    "location_id" INTEGER NOT NULL,

    FOREIGN KEY("location_id") REFERENCES "Location"("id") ON DELETE CASCADE,
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
    "location_id" INTEGER NOT NULL,

    FOREIGN KEY("location_id") REFERENCES "Location"("id") ON DELETE CASCADE
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
CREATE INDEX idx_location_postalcode ON Location(postalcode);

CREATE INDEX idx_vendors_name ON Vendors(vendor_name);
CREATE INDEX idx_items_name ON Items(item_name);
CREATE INDEX idx_items_vendor_id ON Items(vendor_id);
CREATE INDEX idx_items_price ON Items(item_price);
CREATE INDEX idx_sellers_user_id ON Sellers(user_id);
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
BEGIN TRANSACTION;
INSERT INTO "Location" (state, city, postalcode, street) VALUES
('Delhi', 'New Delhi', '110001', 'Janpath'),
('Maharashtra', 'Mumbai', '400001', 'Colaba'),
('Karnataka', 'Bangalore', '560001', 'MG Road'),
('West Bengal', 'Kolkata', '700001', 'Park Street'),
('Tamil Nadu', 'Chennai', '600001', 'Marina Beach Road'),
('Gujarat', 'Ahmedabad', '380001', 'C.G. Road'),
('Rajasthan', 'Jaipur', '302001', 'JLN Marg'),
('Telangana', 'Hyderabad', '500001', 'Banjara Hills'),
('Punjab', 'Chandigarh', '160001', 'Sector 17'),
('Uttar Pradesh', 'Lucknow', '226001', 'Hazratganj');
COMMIT;

BEGIN TRANSACTION;
INSERT INTO "Users" (name, login_id, hashed_password, phone, role, location_id) VALUES
('Raj Kumar', 'rajkumar1', 'hash1', '9812345670', 'buyer', 1),
('Priya Singh', 'priyasingh2', 'hash2', '9823456781', 'seller', 2),
('Amit Patel', 'amitpatel3', 'hash3', '9834567892', 'buyer', 3),
('Sunita Rao', 'sunitarao4', 'hash4', '9845678903', 'seller', 4),
('Vijay Kumar', 'vijaykumar5', 'hash5', '9856789014', 'buyer', 5),
('Anita Desai', 'anitadesai6', 'hash6', '9867890125', 'seller', 6),
('Mohit Sharma', 'mohitsharma7', 'hash7', '9878901236', 'buyer', 7),
('Kavita Krishnan', 'kavitakrishnan8', 'hash8', '9889012347', 'seller', 8),
('Rahul Mehta', 'rahulmehta9', 'hash9', '9890123458', 'buyer', 9),
('Deepika Iyer', 'deepikaiyer10', 'hash10', '9801234569', 'seller', 10);
COMMIT;




BEGIN TRANSACTION;
INSERT INTO "Wallet" (user_id) VALUES
((SELECT id FROM Users WHERE login_id = 'rajkumar1')),
((SELECT id FROM Users WHERE login_id = 'priyasingh2')),
((SELECT id FROM Users WHERE login_id = 'amitpatel3')),
((SELECT id FROM Users WHERE login_id = 'sunitarao4')),
((SELECT id FROM Users WHERE login_id = 'vijaykumar5')),
((SELECT id FROM Users WHERE login_id = 'anitadesai6')),
((SELECT id FROM Users WHERE login_id = 'mohitsharma7')),
((SELECT id FROM Users WHERE login_id = 'kavitakrishnan8')),
((SELECT id FROM Users WHERE login_id = 'rahulmehta9')),
((SELECT id FROM Users WHERE login_id = 'deepikaiyer10'));
COMMIT;

BEGIN TRANSACTION;
INSERT INTO "CreditCard" (type, security_code, expiration_date, card_holder_name, wallet_id) VALUES
('credit', '111', '12/24', 'Raj Kumar', 1),
('debit', '222', '01/25', 'Priya Singh', 2),
('credit', '333', '02/26', 'Amit Patel', 3),
('debit', '444', '03/27', 'Sunita Rao', 4),
('credit', '555', '04/28', 'Vijay Kumar', 5),
('debit', '666', '05/29', 'Anita Desai', 6),
('credit', '777', '06/30', 'Mohit Sharma', 7),
('debit', '888', '07/31', 'Kavita Krishnan', 8),
('credit', '999', '08/32', 'Rahul Mehta', 9),
('debit', '000', '09/33', 'Deepika Iyer', 10);
COMMIT;



BEGIN TRANSACTION;
INSERT INTO "Customer_Feedback" ("item_id", "user_id", "rating", "comment", "date") VALUES
(1, 1, 5, 'Great product, highly recommended!', '2023-01-15 10:00:00'),
(2, 1, 4, 'Very good, but the delivery was late.', '2023-02-16 12:30:00'),
(3, 2, 3, 'Average quality, not as expected.', '2023-03-17 15:45:00'),
(4, 2, 5, 'Exceeded my expectations!', '2023-04-18 09:20:00'),
(5, 3, 2, 'Poor quality, arrived damaged.', '2023-05-19 08:15:00'),
(6, 3, 4, 'Good, but could be better.', '2023-06-20 16:40:00'),
(7, 4, 5, 'Perfect! Just what I needed.', '2023-07-21 14:05:00'),
(8, 4, 1, 'Not at all what was advertised.', '2023-08-22 17:50:00'),
(9, 5, 3, 'It’s okay, but I have some complaints.', '2023-09-23 11:25:00'),
(10, 5, 5, 'Amazing! Will definitely buy again.', '2023-10-24 13:30:00');
COMMIT;

BEGIN TRANSACTION;
INSERT INTO Users (name, login_id, hashed_password, phone, role, deleted, prime_membership, location_id) VALUES
('Ramesh Kumar', 'ramesh@example.com', 'hashedpass123', '+91 9876543210', 'buyer', 0, 1, 1),
('Suresh Singh', 'suresh@example.com', 'hashedpass456', '+91 8765432109', 'seller', 0, 0, 1),
('Meera Patel', 'meera@example.com', 'hashedpass789', '+91 7654321098', 'both', 0, 1, 2),
('Priya Gupta', 'priya@example.com', 'hashedpass987', '+91 6543210987', 'buyer', 0, 0,3),
('Amit Verma', 'amit@example.com', 'hashedpass654', '+91 5432109876', 'seller', 0, 1, 1),
('John Doe', 'john@example.com', 'hashedpass123', '+91 1234567890', 'seller', 0, 0, 4);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO Wallet (user_id) VALUES
(1), (2), (3), (4), (5);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO CreditCard (type, security_code, expiration_date, card_holder_name, wallet_id) VALUES
('credit', '123', '12/25', 'Ramesh Kumar', 1),
('debit', '456', '03/24', 'Suresh Singh', 2),
('credit', '789', '06/27', 'Meera Patel', 3),
('debit', '987', '09/23', 'Priya Gupta', 4),
('credit', '654', '11/26', 'Amit Verma', 5);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO Orders (user_id, shipping_id, is_cancelled, date_of_order, order_summary, grand_total, payment_method) VALUES
(1, 1, 0, '2024-03-10 10:30:00', 'Order for household items', 2500.00, 1),
(3, 2, 0, '2024-03-11 11:45:00', 'Order for electronics', 5000.00, 2);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Shipping (shipping_method, location_id) VALUES
(1, 3),
(2, 4);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Invoice (order_id, seller_id) VALUES
(1, 2),
(2, 4);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Business (owner_id, name, phone_no) VALUES
(2, 'Electronics Emporium', '+91 9876543210'),
(4, 'Tech Solutions', '+91 8765432109'),
((SELECT id FROM Sellers WHERE user_id = (SELECT id FROM Users WHERE name = 'John Doe')), 'Electronics Haven', '+91 9876543210');
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Vendors (vendor_name) VALUES
('Tech World'),
('Gadgets Galore'),
('Electro Enterprises'),
('Appliances Plus'),
('Digital Dreams');
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Items (item_price, item_name, quantity, condition, vendor_id) VALUES
(1500.00, 'Smartphone', 20, 'good', 1),
(2000.00, 'Laptop', 15, 'good', 2),
(300.00, 'Earphones', 50, 'ok', 3),
(500.00, 'Toaster', 10, 'good', 4),
(1000.00, 'Camera', 8, 'good', 5),
(250.00, 'Power Bank', 30, 'ok',4);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Users (name, login_id, hashed_password, phone, role, deleted, prime_membership, location_id) VALUES
('John Doe', 'john1@example.com', 'hashedpass123', '+91 1234567891', 'seller', 0, 0, 3);
COMMIT;



BEGIN TRANSACTION;
INSERT INTO Sellers (user_id, national_taxID, account_no, IFSC_no, bank_branch) VALUES
((SELECT id FROM Users WHERE name = 'John Doe'),  'IN0987654321', '1234567890123456', 'IFSC001', 'Main Branch');
COMMIT;



BEGIN TRANSACTION;
INSERT INTO Business (owner_id, name, phone_no) VALUES
((SELECT id FROM Sellers WHERE user_id = (SELECT id FROM Users WHERE name = 'John Doe')), 'Electronics Haven', '+91 9876543210');
COMMIT;



BEGIN TRANSACTION;
INSERT INTO ItemsOrders (item_id, order_id) VALUES
(1, 1),
(2, 2),
(3, 4),
(4, 5),
(5, 6);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Orders (user_id, shipping_id, is_cancelled, date_of_order, order_summary, grand_total, payment_method) VALUES
(4, 1, 0, '2024-03-15 12:30:00', 'Order for power bank', 250.00, 1),
(5, 2, 0, '2024-03-16 13:45:00', 'Order for camera', 1000.00, 2);
COMMIT;



BEGIN TRANSACTION;
INSERT INTO Shipping (shipping_method, location_id) VALUES
(1, 4),
(2, 3);
COMMIT;

BEGIN TRANSACTION;
INSERT INTO Invoice (order_id, seller_id) VALUES
(3, 5),
(4, 3);
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Business (owner_id, name, phone_no) VALUES
(5, 'Electronics Mart', '+91 7654321098'),
(3, 'Gadget Hub', '+91 6543210987');
COMMIT;


BEGIN TRANSACTION;
INSERT INTO Items (item_price, item_name, quantity, condition, vendor_id) VALUES
(250.00, 'Bluetooth Speaker', 20, 'good', 1),
(100.00, 'USB Flash Drive', 30, 'good', 2);
COMMIT;

BEGIN TRANSACTION;
	INSERT INTO ShippingMethods (method_id, method_name)
	VALUES
	(1, "by land"),
	(2, "by air"),
	(3, "by water");
COMMIT;

INSERT INTO Warehouses (warehouse_name, location_id)
VALUES ('Warehouse A', 1),
       ('Warehouse B', 2),
       ('Warehouse C', 3),
       ('Warehouse D', 4),
       ('Warehouse E', 5);


INSERT INTO ItemsWarehouses(item_id, warehouse_id)
VALUES (1,2)
