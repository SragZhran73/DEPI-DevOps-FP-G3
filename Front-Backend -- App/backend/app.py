from flask import Flask, jsonify, request
from flask_cors import CORS  # Import CORS
import mysql.connector
import os

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Load database configuration from environment variables
DB_CONFIG = {
    'host': os.getenv('DB_HOST'),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'database': os.getenv('DB_NAME')
}

def get_db_connection():
    conn = mysql.connector.connect(**DB_CONFIG)
    return conn

@app.route('/')
def home():
    return "Welcome to the DEV-IT-OPS Hotel "


@app.route('/hotels', methods=['GET'])
def get_hotels():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT HotelID, Name FROM Hotel')
    hotels = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(hotels)

@app.route('/hotel/<string:hotel_id>', methods=['GET'])
def get_hotel(hotel_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute('SELECT * FROM Hotel WHERE HotelID = %s', (hotel_id,))
    hotel = cursor.fetchone()
    cursor.close()
    conn.close()
    return jsonify(hotel) if hotel else ('Not Found', 404)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
