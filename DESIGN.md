# Amazon Database

By Arnav Rustagi, Prashant Mishra, Vijeta Raghuvanshi


## Scope

In this section you should answer the following questions:

* What is the purpose of your database?
* Which people, places, things, etc. are you including in the scope of your database?
* Which people, places, things, etc. are *outside* the scope of your database?

## Database Scope for E-commerce Platform

This section outlines the purpose and scope of the database designed to support e-commerce operations for a platform similar to Amazon.

**Purpose:** The primary function of this database is to streamline and manage e-commerce activities for a tech giant like Amazon. It achieves this by storing and organizing information critical to various aspects of online shopping, including:

* **Users:** This encompasses both customers making purchases and sellers listing products.
* **Items:** The database will house details of all products available for purchase.
* **Orders:** Information pertaining to all orders placed by users will be captured.
* **Inventory:** Inventory levels and management functionalities will be integrated.
* **Business Details:** Seller information relevant to their business operations will be stored.
* **Customer Feedback:** The database will allow for the collection and storage of customer reviews and feedback on products.
* **Delivery:** Details regarding delivery options and processes will be managed.
* **Payment Methods:** Available payment options will be facilitated by the database.
* **Shopping Carts:** Users' shopping cart functionalities, including adding and removing items, will be supported.
* **Vendors:** Information pertaining to vendors supplying products will be included.
**Scope:**

**Within Scope:** The database encompasses all entities directly related to e-commerce activities on the platform. This includes user accounts (both customer and seller), product information, order management, inventory control, seller business details, customer feedback, delivery options, payment methods, shopping cart functionalities, vendor data, and product catalogs.

**Outside Scope:** The database will not include unrelated data or processes. This excludes non-commercial information, social interactions between users, and administrative functions not directly connected to e-commerce transactions.

## Functional Requirements

**User Capabilities:**

The database empowers users with a variety of functionalities, including:

* **Account Management:** Users can create and manage accounts, specifying their roles as customers or sellers.
* **E-commerce Operations:** Users can browse and purchase items, track order history, and provide product feedback.
* **Payment and Delivery Management:** Users can manage their payment methods and shipping addresses, as well as track deliveries.
* **Platform Interaction:** Users can interact with the shopping cart, manage their session states, and access customer service features.

**Limitations:**

The database focuses on e-commerce functionalities. Certain activities fall outside its scope:

* **Non-commerce Activities:** Social networking or administrative functions unrelated to e-commerce are not supported.
* **Data Access Restriction:** Users can only access data relevant to their user roles.
* **External Operations:** Physical product handling, logistics, and legal compliance beyond the digital platform are not managed by the database.

In essence, the database facilitates e-commerce activities while ensuring data security and role-based access.
## Representation

### Entities

Here we describe an e-commerce platform's database design, similar to that of Amazon. It outlines various entities like Users, Orders, and Items, along with their corresponding attributes. User information like name, login credentials, and role are stored, with data types optimized for efficiency. To safeguard data accuracy, unique identifiers and limitations on certain values are implemented. This structured approach allows for effective management of users, transactions, inventory, and overall platform operations.

#### Users
```
Attributes: name, login_id, hashed_password, phone, role, deleted, prime_membership
Types:
name: TEXT
login_id: TEXT (unique)
hashed_password: TEXT
phone: TEXT
role: TEXT (CHECK IN ('buyer', 'seller', 'both'))
deleted: INTEGER (DEFAULT 0)
prime_membership: INTEGER (DEFAULT 0)
Constraints:
login_id is unique to ensure each user has a distinct login identity.
role is constrained to predefined values ('buyer', 'seller', 'both') to enforce role differentiation.
```
#### Location
```
Attributes: user_id, state, city, postalcode, street
Types:
user_id: INTEGER
state: TEXT
city: TEXT
postalcode: TEXT (unique)
street: TEXT
Constraints:
postalcode is unique to ensure each location entry corresponds to a distinct postal code.
```
### Relationships
This section outlines the relationships between various entities in the e-commerce platform's database using pointers:

**Users - Location (One-to-One)**

* A single user points to one corresponding location record.

**Users - Wallet/CreditCard (One-to-Many)**

* A single user record can have pointers to multiple wallet and credit card entries.

**Users - Orders/Invoice (One-to-Many)**

* A single user record can have pointers to multiple orders and invoices they generate.

**Orders - Shipping (One-to-One)**

* Each order record points to a single shipping method.

**Orders - Invoice (One-to-One)**

* Each order record points to a single invoice generated for that order.

**Business - Orders (One-to-Many)**

* A single business record can have pointers to multiple orders they fulfill.

**Vendors - Items (One-to-Many)**

* A single vendor record can have pointers to multiple items they sell.

**Items - Orders (Many-to-Many)**

* An item record can be pointed to by multiple order records (indicating it appears in multiple orders). Conversely, an order record can point to multiple item records (representing the items included in that order).

**Business - Vendors (Many-to-Many)**

* A business record can have pointers to multiple vendors they collaborate with. Similarly, a vendor record can point to multiple businesses they supply products to.

For a visual representation of these relationships, please refer to the entity-relationship diagram (ERD) provided in the database design documentation. Link provided [here](https://dbdiagram.io/d/65edb2d3b1f3d4062c8dc4c0)
## Optimizations
This section details the implementation of views and indexes to enhance query performance and streamline data access within the e-commerce platform's database.

**Views:**

* **PublicSellersView:** This view aggregates and presents specific seller information like names, business names, and phone numbers, catering to users seeking basic seller details.
* **AvailableItems:** This view offers a simplified list of available items, aiding users in browsing the current inventory.
* **PrimeMembers:** This view identifies users with active prime memberships, facilitating targeted operations towards this user group.
* **ActiveUsers:** This view provides a list of active users based on our soft-deletion implementation, excluding those flagged for deletion.
* **TotalRevenue:** This view provides the total revenue generated.
* **MonthlySales:** This view provides the view of items that were sold in the current month.
* **AverageRating:** This view provides a view of items id and their average rating.

**Triggers:**
* **AddOrderHistory:** This trigger updates the order history when their is an item which shopped.
* **RemoveItemWhenZero:** This trigger removes an item from item table when it's quantity is zero.
* **UpdateTotalPrice:** This trigger updates the total price of the cart items when either an item is added/deleted.
**Indexes:**

For optimized query performance, indexes have been strategically placed on frequently accessed columns across various tables:

* **Users Table:**
    * `idx_users_name`: Enables faster searches and sorting based on user names.
    * `idx_users_login_id`: Expedites user account retrieval using login IDs.
    * `idx_users_phone`: Facilitates efficient user record retrieval by phone numbers.
* **Location Table:**
    * `idx_location_user_id`: Accelerates location-related queries for specific users.
    * `idx_location_postalcode`: Enables rapid location data retrieval based on postal codes.
* **Vendors Table:**
    * `idx_vendors_name`: Allows for quick access to vendor information by name.
* **Items Table:**
    * `idx_items_name`: Speeds up searches and sorting based on item names.
    * `idx_items_vendor_id`: Enables efficient retrieval of items belonging to specific vendors.
    * `idx_items_price`: Expedites queries involving item prices.
* **Sellers Table:**
    * `idx_sellers_user_id`: Provides quick access to seller information using their user IDs.

By incorporating these views and indexes, the database design strives to ensure efficient data retrieval and optimized query performance for a smooth user experience.
## Limitations
These are the limitations of our design
* **Physical Product handling:** Our database is incapable of handling fine details for deliveries, incase we use our own delivery personnel, like who is the deliver person assigned, how long will each part of the shipment take.
* **Recurring Prime Payments:** Prime membership often has recurring payments, we do not have provisions for tracking when should the user pay for the prime membership
* **External legal and financial processes:** Our design is not suited for external financial issues, like bank invoices, taxes etc. Nor provisions for legal issues like in-case someone did not pay our platform what actions we might take against them.
* **Content Management System:** Our database does not have provisions to manage more detailed content about the product, except a basic description, nor any provisions to save images of the product etc.
* **Search Tags:** Our database does not have provisions to have tags about a product to allow us to search the database for specific tags.
