INSERT INTO ShoppingCart (user_id, total_price) VALUES (
(
	SELECT id FROM Users
	WHERE login_id = "CoolUsername69"
), 0);

-- we could have optimised this with triggers!
INSERT INTO ItemsInCart 
(cart_id, item_id, quantity, price) 
VALUES 
((
	SELECT cart_id
	FROM ShoppingCart
	JOIN "Users" ON "Users"."id" = "ShoppingCart"."user_id"
	WHERE login_id = "CoolUsername69"
), (
	SELECT item_id
	FROM Items
	WHERE item_name = "Toaster"
), 1, (
	SELECT item_price
	FROM Items
	WHERE item_name = "Toaster"
));

INSERT INTO ItemsInCart 
(cart_id, item_id, quantity, price) 
VALUES 
((
	SELECT cart_id
	FROM ShoppingCart
	JOIN "Users" ON "Users"."id" = "ShoppingCart"."user_id"
	WHERE login_id = "CoolUsername69"
), (
	SELECT item_id
	FROM Items
	WHERE item_name = "Earphones"
), 1, (
	SELECT item_price
	FROM Items
	WHERE item_name = "Earphones"
));

INSERT INTO Orders 
(user_id, grand_total, shipping_id, date_of_order)
VALUES 
(
	(SELECT id FROM "Users" WHERE login_id = "CoolUsername69"), 
	-- triggers wow also a case of which came first the chicken or the egg?
	(SELECT grand_total FROM "Orders"), 
	(SELECT method_id FROM "ShippingMethods" WHERE method_name = "by air"),
	CURRENT_TIMESTAMP
);

INSERT INTO "Shipping"
(shipping_method, order_id, location_id)
VALUES
(
	(SELECT method_id FROM "ShippingMethods" WHERE "method_name" = "by air"),
	(SELECT order_id FROM "Orders"),
	(SELECT "Location"."id" FROM "Location"
	JOIN "Users" ON "Location"."id" = "Users"."location_id" 
	WHERE "login_id" = "CoolUsername69")
);
