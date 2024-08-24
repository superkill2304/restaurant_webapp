import sqlite3 
import hashlib 
import os


def user_registration():

    #getting registration data 

    first_name = str(input("Introduce Your first name: "))
    last_name = str(input("Introduce your last name: "))
    email = str(input("Introduce your email: "))
    password = str(input("Introduce your password: "))

    #creating hashing entities 
    salt = os.urandom(16).hex()
    hashed_password = hashlib.sha256((password + salt).encode('utf-8')).hexdigest()

    #storing data in array
    
    data = (first_name,last_name,email,hashed_password,salt)
    con = sqlite3.connect("main.db")
    cur = con.cursor()

    cur.execute("""INSERT INTO users(first_name,last_name,email,password,salt)
                    VALUES(?,?,?,?,?)
                
                """,data)
    
    con.commit()
    con.close()


def user_validation(input_email,input_password):

    con= sqlite3.connect("main.db")
    cur = con.cursor()
    user_id = cur.execute("""SELECT id FROM users WHERE email = ? """,(input_email,)).fetchone()
    
    if user_id:
        
        password, salt = cur.execute("SELECT password, salt FROM users WHERE id = ?",user_id).fetchone()

        con.close()
        if password == hashlib.sha256((input_password + salt).encode('utf-8')).hexdigest():
            
            return user_id
        else:
            print("Incorrect Password")
        
    else:
        print("Email not registered")




def add_inventory():
    
    if user_id := user_validation(input("Introduce Your email: "),input("Introduce your password: ")):
        
        category = input("Introduce the category")
        name = input("Introduce the name")
        price = str(float(input("Introduce the price")))
        quantity = str(float(input("Introduce the quantity")))
        supplier = input("Introduce the name of the supplier")
        date = input("Introduce the date")

        data = (str(user_id[0]),category,name,price,quantity,supplier,date)

        con = sqlite3.connect("main.db")
        cur = con.cursor()

        cur.execute("""
            INSERT INTO inventory(user_id,category,name,price,quantity,supplier,date) 
            VALUES (?,?,?,?,?,?,?)
        """,data)

        con.commit()
        con.close()
    else: 
        return False
    
add_inventory()