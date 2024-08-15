CREATE TABLE IF NOT EXISTS "users"(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" UNIQUE TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "salt" TEXT NOT NULL,
    "method" TEXT NOT NULL,
    PRIMARY KEY("id")
    
);

CREATE TABLE IF NOT EXISTS "inventory"(

    "id" INTEGER,
    "user_id" INTEGER,
    "category" TEXT NOT NULL CHECK("category" IN ("A","B","C","D","E","F","G")),
    "name" TEXT NOT NULL,
    "price" REAL NOT NULL CHECK("price" > 0),
    "quantity" REAL NOT NULL,
    "supplier" TEXT,
    "date"  DATE, 
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id") 
);

CREATE TABLE IF NOT EXISTS "products"(

    "id" INTEGER,
    "user_id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "price" REAL, 
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id")
);

CREATE TABLE IF NOT EXISTS "sells"(
    "id" INTEGER,
    "user_id" INTEGER,
    "product_id" INTEGER
    "quantity" INTEGER NOT NULL CHECK("quantity" > 0),
    "date" DATE DEFAULT CURRENT_TIMESTAMP, 
    PRIMARY KEY("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("product_id") REFERENCES "products"("id")
)