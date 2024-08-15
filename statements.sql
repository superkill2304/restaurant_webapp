
CREATE TABLE IF NOT EXISTS "users"(
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "salt" TEXT NOT NULL,
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
);

CREATE TABLE IF NOT EXISTS "recipe"(
    "product_id" INTEGER,
    "user_id" INTEGER, 
    "inventory_id" INTEGER,
    "quantity" REAL,
    FOREIGN KEY("product_id") REFERENCES "products"("id"),
    FOREIGN KEY("user_id") REFERENCES "users"("id"),
    FOREIGN KEY("inventory_id") REFERENCES "inventory"("id")
);

CREATE TABLE IF NOT EXISTS "inventory_log"(

    "inventory_id" INTEGER,
    "user_id" INTEGER,
    "category" TEXT NOT NULL CHECK("category" IN ("A","B","C","D","E","F","G")),
    "name" TEXT NOT NULL,
    "price" REAL NOT NULL CHECK("price" > 0),
    "quantity" REAL NOT NULL,
    "supplier" TEXT,
    "date"  DATE, 
    "action" TEXT,
    FOREIGN KEY("user_id") REFERENCES "users"("id") 
);

CREATE TRIGGER added_to_inventory
    AFTER INSERT ON "inventory"
    FOR EACH ROW
    BEGIN
        INSERT INTO "inventory_log"("inventory_id","user_id","category","name","price","quantity","supplier","date","action")
        VALUES(NEW."id",NEW."user_id",NEW."category",NEW."name",NEW."price",NEW."quantity",NEW."supplier",NEW."date",'added');
    END;    

CREATE TRIGGER deleted_from_inventory
    BEFORE DELETE ON "inventory"
    FOR EACH ROW
    BEGIN
        INSERT INTO "inventory_log"("inventory_id","user_id","category","name","price","quantity","supplier","date","action")
        VALUES(OLD."id",OLD."user_id",OLD."category",OLD."name",OLD."price",OLD."quantity",OLD."supplier",OLD."date",'deleted');
    END;    