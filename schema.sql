-- location remove, refer to table location

DROP TABLE IF EXISTS "Users";
CREATE TABLE "Users" (
    "id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "login_id" TEXT NOT NULL UNIQUE,
    "hashed_password" TEXT NOT NULL,
    "phone" NUMERIC NOT NULL,
    "role" TEXT NOT NULL CHECK("role" IN ('buyer', 'seller', 'both')),
    -- soft deletion (vijeta)
    -- prime membership (vieta)
    PRIMARY KEY("id")
);

DROP TABLE IF EXISTS "Location";
CREATE TABLE "Location" (
    "user_id" INTEGER,
    "state" TEXT,
    "city" TEXT,
    "postalcode" NUMERIC,
    "street" TEXT,
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);

-- updated using a trigger (vijeta)
DROP TABLE IF EXISTS "Order_History";
CREATE TABLE "Order_History" (
    "order_id" INTEGER NOT NULL,
    "item_id" INTEGER NOT NULL,
    "user_id" INTEGER,
    "amount" NUMERIC NOT NULL CHECK("amount" != 0),
    "payment_method" TEXT,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status" TEXT NOT NULL CHECK("status" IN ('pending', 'delivered', 'cancelled')),
    PRIMARY KEY("order_id"),

    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE,
    FOREIGN KEY("item_id") REFERENCES "Items"("id")
);

DROP TABLE IF EXISTS "Customer_Feedback";
CREATE TABLE "Customer_Feedback" (
    "item_id" INTEGER,
    "user_id" INTEGER,
    "rating" NUMERIC NOT NULL CHECK(rating >= 1 AND rating <= 5),
    "comment" TEXT,
    "date" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY("item_id","user_id"),
    FOREIGN KEY("item_id") REFERENCES "Items"("id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);

DROP TABLE IF EXISTS "Sellers";
CREATE TABLE "Sellers" (
    "id" INTEGER,
    "user_id" INTEGER,
    "state_taxID" INTEGER,
    "national_taxID" NUMERIC NOT NULL,
    "account_no" TEXT NOT NULL,
    "IFSC_no" TEXT NOT NULL,
    "bank_branch" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "Users"("id") ON DELETE CASCADE
);

DROP TABLE IF EXISTS "Sold_By";
CREATE TABLE "Sold_By" (
    "item_id" INTEGER,
    "seller_id" INTEGER,
    FOREIGN KEY("item_id") REFERENCES "Items"("id") ON DELETE CASCADE,
    FOREIGN KEY("seller_id") REFERENCES "Sellers"("id") ON DELETE CASCADE
);

DROP TABLE IF EXISTS "Business";
CREATE TABLE "Business" (
    "id" INTEGER NOT NULL,
    "owner_id" INTEGER,
    "name" TEXT NOT NULL,
    "phone_no" NUMERIC,
    "state" TEXT,
    "city" TEXT,
    "postalcode" NUMERIC,
    "street" TEXT,
    PRIMARY KEY("id"),
    FOREIGN KEY("owner_id") REFERENCES "Sellers"("id") ON DELETE CASCADE
);

-- view to remove item if quantity = 0 (vijeta)
DROP TABLE IF EXISTS "Items";
CREATE TABLE "Items" (
    "item_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "item_price" REAL NOT NULL,
    "item_name" TEXT NOT NULL,

    "quantity" INTEGER DEFAULT 0,
    "condition" TEXT DEFAULT 'ok' CHECK("condition" IN ('ok', 'bad', 'good')), -- this is the condition of the article (good, bad etc)
    "vendor_id" INTEGER DEFAULT NULL,
    "seller_id" INTEGER DEFAULT NULL,

    FOREIGN KEY("vendor_id") REFERENCES "Vendor"("vendor_id") ON DELETE SET DEFAULT,
    FOREIGN KEY("seller_id") REFERENCES "Seller"("seller_id") ON DELETE SET DEFAULT
);

DROP TABLE IF EXISTS "Warehouses";
CREATE TABLE "Warehouses" (
    "warehouse_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "warehouse_name" TEXT NOT NULL,
    "street_name" TEXT DEFAULT NULL,
    "city_name" TEXT DEFAULT NULL,
    "zip_code" INTEGER DEFAULT NULL,
    "state_id" INTEGER NOT NULL,

    FOREIGN KEY ("state_id") REFERENCES "States"("state_id")
);

DROP TABLE IF EXISTS "States";
CREATE TABLE "States" (
    "state_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "state_name" TEXT NOT NULL
);

DROP TABLE IF EXISTS "ItemsWarehouses";
CREATE TABLE "ItemsWarehouses" (
    "item_id" INTEGER UNIQUE,
    "warehouse_id" INTEGER UNIQUE
);

DROP TABLE IF EXISTS "Orders";
CREATE TABLE "Orders" (
    "order_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "is_cancelled" TEXT DEFAULT NULL,
    "date_of_order" TEXT DEFAULT CURRENT_TIMESTAMP,
    "order_summary" TEXT DEFAULT NULL,
    "grand_total" REAL NOT NULL DEFAULT 0.0,

    "payment_method" INTEGER NOT NULL,
    "user_id" INTEGER NOT NULL,
    "shipping_id" INTEGER NOT NULL,

    FOREIGN KEY ( "user_id" ) REFERENCES "Users"("user_id") ON DELETE CASCADE,
    FOREIGN KEY ( "shipping_id" ) REFERENCES "Shipping"("shipping_id"),
    FOREIGN KEY ( "payment_method" ) REFERENCES "PaymentMethods"("method_id")
);

-- insert statements at the end (Arnav)
DROP TABLE IF EXISTS "PaymentMethods";
CREATE TABLE "PaymentMethods" (
    "method_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "method_name" TEXT NOT NULL UNIQUE
);

DROP TABLE IF EXISTS "ItemsOrders";
CREATE TABLE "ItemsOrders" (
    "item_id" INTEGER UNIQUE,
    "order_id" INTEGER UNIQUE
);

-- add trigger to add order_history (Arnav)
DROP TABLE IF EXISTS "OrderHistory";
CREATE TABLE "OrderHistory" (
    "user_id" INTEGER UNIQUE,
    "order_id" INTEGER UNIQUE,

    "date_of_order" TEXT DEFAULT CURRENT_TIMESTAMP,
    "payment_method" INTEGER NOT NULL,
    "order_summary" TEXT DEFAULT NULL,
    "grand_total" REAL DEFAULT 0.0 NOT NULL,

    FOREIGN KEY ( "payment_method" ) REFERENCES "PaymentMethods"("method_id")
);


DROP TABLE IF EXISTS "Wallet";
CREATE TABLE "Wallet" (
    "wallet_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "street_name" TEXT DEFAULT NULL,
    "city_name" TEXT DEFAULT NULL,
    "zip_code" INTEGER DEFAULT NULL,
    
    "user_id" INTEGER NOT NULL,
    "state_id" INTEGER NOT NULL,

    FOREIGN KEY ("user_id") REFERENCES "Users"("user_id") ON DELETE CASCADE,
    FOREIGN KEY ("state_id") REFERENCES "States"("state_id")
);

DROP TABLE IF EXISTS "Invoice";
CREATE TABLE "Invoice" (
    "invoice_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "order_id" INTEGER NOT NULL,
    "seller_id" INTEGER NOT NULL,
    
    FOREIGN KEY ("order_id") REFERENCES "Orders"("order_id"),
    FOREIGN KEY ("seller_id") REFERENCES "Seller"("seller_id")
);

DROP TABLE IF EXISTS "Seller";
CREATE TABLE "Seller" (
    "user_id" INTEGER PRIMARY KEY,
    "tax_id" TEXT NOT NULL CHECK(length ( tax_id ) = 9) UNIQUE,
    "state_tax_id" TEXT NOT NULL CHECK(length ( state_tax_id ) = 9),
    "bank_info" TEXT DEFAULT NULL
);

-- add trigger on order placement payment gets updated (Arnav)
DROP TABLE IF EXISTS "Payment";
CREATE TABLE "Payment" (
    "payment_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "invoice_id" INTEGER NOT NULL,
    "payment_method" INTEGER NOT NULL,

    FOREIGN KEY ("user_id") REFERENCES "User"("user_id") ON DELETE CASCADE,
    FOREIGN KEY ("invoice_id") REFERENCES "Invoice"("invoice_id"),
    FOREIGN KEY ("payment_method") REFERENCES "PaymentMethods"("method_id")
);

DROP TABLE IF EXISTS "CreditCard";
CREATE TABLE "CreditCard" (
    "card_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "type" TEXT NOT NULL CHECK("type" IN ("credit", "debit")),
    "security_code" TEXT NOT NULL CHECK( LENGTH (security_code ) = 12),
    "expiration_data" TEXT NOT NULL,
    "card_holder_name" TEXT NOT NULL,
    "wallet_id" INTEGER NOT NULL,

    FOREIGN KEY ("wallet_id") REFERENCES "Wallet"("wallet_id") ON DELETE CASCADE
);

DROP TABLE IF EXISTS "Shipping";
CREATE TABLE "Shipping" (
    "shipping_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "shipping_method" INTEGER NOT NULL,
    "street_name" TEXT DEFAULT NULL,
    "city_name" TEXT DEFAULT NULL,
    "zip_code" INTEGER DEFAULT NULL,
    "state_id" INTEGER NOT NULL,

    FOREIGN KEY ("shipping_method") REFERENCES "ShippingMethods"("method_id") ON DELETE CASCADE,
    FOREIGN KEY ("state_id") REFERENCES "States"("state_id")
);

-- default inserts
DROP TABLE IF EXISTS "ShippingMethods";
CREATE TABLE "ShippingMethods" (
    "method_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "method_name" TEXT
);

DROP TABLE IF EXISTS "Customers";
CREATE TABLE "Customers" (
    "user_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "wallet_id" INTEGER NOT NULL,
    "unique_cart_id" INTEGER NOT NULL UNIQUE,

    FOREIGN KEY ("wallet_id") REFERENCES "Wallet"("wallet_id"),
    FOREIGN KEY ("unique_cart_id") REFERENCES "ShoppingCart"("cart_id")
);

DROP TABLE IF EXISTS "Departments";
CREATE TABLE "Departments" (
    "department_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "department_name" TEXT NOT NULL
);

DROP TABLE IF EXISTS "Categories";
CREATE TABLE "Categories" (
    "category_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "category_name" TEXT NOT NULL,
    "department_id" INTEGER,
    FOREIGN KEY ("department_id") REFERENCES "Departments"("department_id") ON DELETE CASCADE
);

DROP TABLE IF EXISTS "Catalogs";
CREATE TABLE "Catalogs" (
    "catalog_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "catalog_name" TEXT NOT NULL
);

DROP TABLE IF EXISTS "Vendors";
CREATE TABLE "Vendors" (
    "vendor_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "vendor_name" TEXT NOT NULL
);

DROP TABLE IF EXISTS "Items";
CREATE TABLE "Items" (
    "item_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "catalog_id" INTEGER,
    "vendor_id" INTEGER,
    FOREIGN KEY ("catalog_id") REFERENCES "Catalogs"("catalog_id") ON DELETE CASCADE,
    FOREIGN KEY ("vendor_id") REFERENCES "Vendors"("vendor_id") ON DELETE CASCADE
);

DROP TABLE IF EXISTS "Customers";
CREATE TABLE "Customers" (
    "user_id" INTEGER PRIMARY KEY AUTOINCREMENT
);

DROP TABLE IF EXISTS "Orders";
CREATE TABLE "Orders" (
    "order_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER,
    "item_id" INTEGER NOT NULL,
    "status" TEXT NOT NULL,
    FOREIGN KEY ("user_id") REFERENCES "Customers"("user_id") ON DELETE SET NULL,
    FOREIGN KEY ("item_id") REFERENCES "Items"("item_id") ON DELETE CASCADE
);

-- add trigger to automatically update total_price (Prashant)
DROP TABLE IF EXISTS "ShoppingCart";
CREATE TABLE "ShoppingCart" (
    "cart_id" INTEGER PRIMARY KEY AUTOINCREMENT,
    "user_id" INTEGER NOT NULL,
    "total_price" DECIMAL(10,2) NOT NULL,
    FOREIGN KEY ("user_id") REFERENCES "Customers"("user_id") ON DELETE CASCADE
);

CREATE INDEX "login_id_index" ON "users"("login_id");
CREATE INDEX "history_index" ON "order_history"("user_id");
CREATE INDEX "customer_feedback_index" ON "customer_feedback"("user_id");
CREATE INDEX "sold_by_index" ON "sold_by"("seller_id");
CREATE INDEX "owner_id_index" ON "business"("owner_id");