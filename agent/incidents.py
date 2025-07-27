# incidents.py
from flask import Blueprint, request, jsonify
from firebase_utils import add_incident_to_firestore, update_incident_status_in_firestore

incidents_bp = Blueprint('incidents', __name__)

@incidents_bp.route('/dispatch', methods=['POST'])
def dispatch_incident():
    data = request.get_json()

    # Basic input validation
    if not data or not all(key in data for key in ['timestamp', 'incident_type', 'description', 'coordinates']):
        return jsonify({'error': 'Invalid input data'}), 400

    incident_type = data['incident_type']
    timestamp = data['timestamp']
    description = data['description']
    coordinates = data['coordinates']
    
    # Add status with initial value 'received'
    status = 'received'

    # Create incident data dictionary
    incident_data = {
        'timestamp': timestamp,
        'incident_type': incident_type,
        'description': description,
        'coordinates': coordinates,
        'status': status
    }

    # Add incident to Firestore
    incident_id = add_incident_to_firestore(incident_data)

    # Dispatch Logic based on incident_type
    if incident_type == 'Medical':
        # Logic for medical unit dispatch
        print(f"Dispatching medical unit for incident at {timestamp} at coordinates {coordinates}. Description: {description}. Status: {status}")
        # Add your medical dispatch code here (e.g., interacting with another service, updating a database)
        message = "Medical unit dispatched."
    elif incident_type == 'Police':
        # Logic for police unit dispatch
        print(f"Dispatching police unit for incident at {timestamp} at coordinates {coordinates}. Description: {description}. Status: {status}")
        # Add your police dispatch code here
        message = "Police unit dispatched."
    elif incident_type == 'Fire':
        # Logic for fire safety dispatch
        print(f"Dispatching fire safety for incident at {timestamp} at coordinates {coordinates}. Description: {description}. Status: {status}")
        # Add your fire safety dispatch code here
        message = "Fire safety dispatched."
    elif incident_type == 'Other':
        # Logic for other support staff dispatch
        print(f"Dispatching support staff for incident at {timestamp} at coordinates {coordinates}. Description: {description}. Status: {status}")
        # Add your support staff dispatch code here
        message = "Support staff dispatched."
    else:
        return jsonify({'error': 'Unknown incident type'}), 400

    return jsonify({'message': message, 'status': status, 'incident_id': incident_id}), 200

@incidents_bp.route('/update_status', methods=['POST'])
def update_incident_status():
    data = request.get_json()
    if not data or not all(key in data for key in ['incident_id', 'status']):
        return jsonify({'error': 'Invalid input data. "incident_id" and "status" fields are required.'}), 400

    incident_id = data['incident_id']
    new_status = data['status']

    success = update_incident_status_in_firestore(incident_id, new_status)

    if success:
        return jsonify({'message': f'Incident {incident_id} status updated to {new_status}'}), 200
    else:
        return jsonify({'error': f'Could not update status for incident {incident_id}'}), 500