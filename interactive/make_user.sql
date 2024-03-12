-- register location
INSERT INTO Location 
(state, city, postalcode, street) 
VALUES 
("Punjab", "Chandigarh", "140306", "Plaksha road");

-- register user
INSERT INTO Users
(name, login_id, hashed_password, phone, role, prime_membership, location_id)
VALUES
("Gopal Krishna", "CoolUsername69", "&#$WENUJW*GH&DH", "+91 4242424242", "buyer", FALSE, (
		SELECT id FROM Location WHERE postalcode = "140306"
));

-- making a wallet!!
INSERT INTO Wallet (user_id) VALUES ((
	SELECT id FROM Users WHERE login_id = "CoolUsername69"
));

-- registering a credit card
INSERT INTO CreditCard
(type, security_code, expiration_date, card_holder_name, wallet_id) VALUES (
	"debit",
	"123",
	"01/29",
	"Gopal Krishna",
	(SELECT id FROM "Users" 
	JOIN "Wallet" ON "Users"."id" = "Wallet"."user_id" 
	WHERE login_id = "CoolUsername69")
)
