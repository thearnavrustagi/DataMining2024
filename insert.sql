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
