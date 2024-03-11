--inserting thr data for user's table
BEGIN TRANSACTION;
INSERT INTO "Users" (name, login_id, hashed_password, phone, role) VALUES
('Raj Kumar', 'rajkumar1', 'hash1', '9812345670', 'buyer'),
('Priya Singh', 'priyasingh2', 'hash2', '9823456781', 'seller'),
('Amit Patel', 'amitpatel3', 'hash3', '9834567892', 'buyer'),
('Sunita Rao', 'sunitarao4', 'hash4', '9845678903', 'seller'),
('Vijay Kumar', 'vijaykumar5', 'hash5', '9856789014', 'buyer'),
('Anita Desai', 'anitadesai6', 'hash6', '9867890125', 'seller'),
('Mohit Sharma', 'mohitsharma7', 'hash7', '9878901236', 'buyer'),
('Kavita Krishnan', 'kavitakrishnan8', 'hash8', '9889012347', 'seller'),
('Rahul Mehta', 'rahulmehta9', 'hash9', '9890123458', 'buyer'),
('Deepika Iyer', 'deepikaiyer10', 'hash10', '9801234569', 'seller');
COMMIT;


--inserting thr data for location's table
BEGIN TRANSACTION;
INSERT INTO "Location" (user_id, state, city, postalcode, street) VALUES
(1, 'Delhi', 'New Delhi', '110001', 'Janpath'),
(2, 'Maharashtra', 'Mumbai', '400001', 'Colaba'),
(3, 'Karnataka', 'Bangalore', '560001', 'MG Road'),
(4, 'West Bengal', 'Kolkata', '700001', 'Park Street'),
(5, 'Tamil Nadu', 'Chennai', '600001', 'Marina Beach Road'),
(6, 'Gujarat', 'Ahmedabad', '380001', 'C.G. Road'),
(7, 'Rajasthan', 'Jaipur', '302001', 'JLN Marg'),
(8, 'Telangana', 'Hyderabad', '500001', 'Banjara Hills'),
(9, 'Punjab', 'Chandigarh', '160001', 'Sector 17'),
(10, 'Uttar Pradesh', 'Lucknow', '226001', 'Hazratganj');
COMMIT;



--inserting thr data for wallet's table
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

--inserting thr data for credit card's table
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



--For customer feedback
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
