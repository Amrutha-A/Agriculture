from flask import Flask, request, redirect, url_for, render_template, session
import mysql.connector
from db_config import get_db_connection
import bcrypt

app = Flask(__name__)
app.secret_key = 'your_secret_key'  # Change this to a random secret key

# Home route
@app.route('/')
def home():
    return render_template('home.html')

# Register route
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        farmer_name = request.form['farmer_name']
        village_id = request.form['village_id']
        phone_no = request.form['phone_no']
        password = request.form['password']
        
        password_hash = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
        
        conn = get_db_connection()
        cursor = conn.cursor()
        
        # Check if the farmer or phone number already exists
        cursor.execute('SELECT * FROM Farmer WHERE FarmerName = %s OR PhoneNo = %s', (farmer_name, phone_no))
        existing_farmer = cursor.fetchone()
        
        if existing_farmer:
            return 'Farmer with the same name or phone number already exists.'
        
        # Insert new farmer into the Farmer table
        cursor.execute('INSERT INTO Farmer (FarmerName, VillageID, PhoneNo, PasswordHash) VALUES (%s, %s, %s, %s)',
                       (farmer_name, village_id, phone_no, password_hash))
        farmer_id = cursor.lastrowid
        
        # Log the registration
        cursor.execute('INSERT INTO FarmerRegistrationLog (FarmerID, RegisteredAt) VALUES (%s, NOW())',
                       (farmer_id,))
        
        conn.commit()
        cursor.close()
        conn.close()
        
        return redirect(url_for('login'))
    
    # Fetch villages for dropdown
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT VillageID, VillageName FROM Village')
    villages = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('register.html', villages=villages)

# Login route
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        farmer_name = request.form['farmer_name']
        password = request.form['password']
        
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute('SELECT * FROM Farmer WHERE FarmerName = %s', (farmer_name,))
        farmer = cursor.fetchone()
        
        if farmer and bcrypt.checkpw(password.encode('utf-8'), farmer['PasswordHash'].encode('utf-8')):
            session['farmer_id'] = farmer['FarmerID']
            return redirect(url_for('register_crop'))
        else:
            return 'Invalid credentials'
    
    return render_template('login.html')

# Logout route
@app.route('/logout')
def logout():
    session.pop('farmer_id', None)
    return redirect(url_for('home'))

# Register crop route with dropdowns
@app.route('/register_crop', methods=['GET', 'POST'])
def register_crop():
    if 'farmer_id' not in session:
        return redirect(url_for('login'))

    if request.method == 'POST':
        crop_id = request.form['crop_id']
        acreage = request.form['acreage']
        
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute('INSERT INTO FarmerCrop (FarmerID, CropID, Acreage) VALUES (%s, %s, %s)',
                       (session['farmer_id'], crop_id, acreage))
        conn.commit()
        cursor.close()
        conn.close()
        
        return redirect(url_for('view_crops'))
    
    # Fetch crops for dropdown
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT CropID, CropName FROM Crop')
    crops = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('register_crop.html', crops=crops)

# View crops route
@app.route('/view_crops')
def view_crops():
    if 'farmer_id' not in session:
        return redirect(url_for('login'))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    
    query = """
    SELECT
        c.CropName,
        SUM(fc.Acreage) AS TotalAcreage
    FROM
        FarmerCrop fc
    JOIN
        Crop c ON fc.CropID = c.CropID
    GROUP BY
        c.CropName;
    """
    
    cursor.execute(query)
    crops_data = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('view_crops.html', crops_data=crops_data)

if __name__ == '__main__':
    app.run(debug=True)
