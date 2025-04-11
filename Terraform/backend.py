from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
import os
import boto3
from botocore.exceptions import ClientError
import json

# Create the Flask application
app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Get region from environment variable
region = os.environ.get('AWS_REGION', 'ap-northeast-1')

# Get secret name from environment variable
secret_name = os.environ.get('DB_SECRET_NAME')

try:
    # Initialize the Secrets Manager client
    session = boto3.session.Session()
    client = session.client(service_name='secretsmanager', region_name=region)
    
    # Retrieve database credentials from Secrets Manager
    response = client.get_secret_value(SecretId=secret_name)
    db_secrets = json.loads(response['SecretString'])
    
    # Extract values
    db_username = db_secrets['username']
    db_password = db_secrets['password']
    db_endpoint = db_secrets['host']
    db_name = db_secrets['dbname']
    
    # Construct the database URI
    db_uri = f"mysql+pymysql://{db_username}:{db_password}@{db_endpoint}/{db_name}"
    
except Exception as e:
    # Fallback to environment variables if secrets manager fails
    print(f"Error retrieving database credentials from Secrets Manager: {e}")
    print("Using environment variables for database connection.")
    
    db_username = os.environ.get('DB_USERNAME')
    db_password = os.environ.get('DB_PASSWORD')
    db_endpoint = os.environ.get('DB_ENDPOINT')
    db_name = os.environ.get('DB_NAME')
    
    # Check if all environment variables are set
    if not all([db_username, db_password, db_endpoint, db_name]):
        raise EnvironmentError("Database credentials not available. Set environment variables or fix Secrets Manager access.")
        
    db_uri = f"mysql+pymysql://{db_username}:{db_password}@{db_endpoint}/{db_name}"

# MySQL Database Configuration
app.config['SQLALCHEMY_DATABASE_URI'] = db_uri
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Initialize the database
db = SQLAlchemy(app)

# User Model
class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(100), unique=True, nullable=False)
    phone = db.Column(db.String(20), nullable=False)
    
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'email': self.email,
            'phone': self.phone
        }

# Create database tables
def init_db():
    with app.app_context():
        db.create_all()

# API Routes
@app.route('/api/users', methods=['GET'])
def get_users():
    users = User.query.all()
    return jsonify([user.to_dict() for user in users])

@app.route('/api/users', methods=['POST'])
def create_user():
    data = request.json
    new_user = User(
        name=data['name'], 
        email=data['email'], 
        phone=data['phone']
    )
    db.session.add(new_user)
    db.session.commit()
    return jsonify(new_user.to_dict()), 201

@app.route('/api/users/<int:user_id>', methods=['GET'])
def get_user(user_id):
    user = User.query.get_or_404(user_id)
    return jsonify(user.to_dict())

@app.route('/api/users/<int:user_id>', methods=['PUT'])
def update_user(user_id):
    user = User.query.get_or_404(user_id)
    data = request.json
    user.name = data['name']
    user.email = data['email']
    user.phone = data['phone']
    db.session.commit()
    return jsonify(user.to_dict())

@app.route('/api/users/<int:user_id>', methods=['DELETE'])
def delete_user(user_id):
    user = User.query.get_or_404(user_id)
    db.session.delete(user)
    db.session.commit()
    return '', 204

# Simplified setup script
if __name__ == '__main__':
    init_db()  # Create database tables
    app.run(host='0.0.0.0', port=5000, debug=True)




