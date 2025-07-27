import firebase_admin
from firebase_admin import credentials, firestore
from firebase_admin.firestore import GeoPoint

# Initialize Firebase Admin SDK
# Make sure to replace 'path/to/your/firestoreSA.json' with the actual path to your service account key file
# if it's not in the root directory.
try:
    firebase_admin.get_app()
except ValueError:
    cred = credentials.Certificate('firestoreSA.json')
    firebase_admin.initialize_app(cred)

db = firestore.client()

def add_incident_to_firestore(incident_data):
    """Adds a new incident to Firestore."""
    try:
        # Convert coordinates to GeoPoint if present
        if 'coordinates' in incident_data and isinstance(incident_data['coordinates'], list) and len(incident_data['coordinates']) == 2:
            incident_data['coordinates'] = GeoPoint(incident_data['coordinates'][0], incident_data['coordinates'][1])

        doc_ref = db.collection('incidents').document()
        doc_ref.set(incident_data)
        return doc_ref.id
    except Exception as e:
        print(f"Error adding incident to Firestore: {e}")
        return None

def update_incident_in_firestore(incident_id, updates):
    """Updates an existing incident in Firestore."""
    try:
        doc_ref = db.collection('incidents').document(incident_id)

        # Convert coordinates to GeoPoint if present in updates
        if 'coordinates' in updates and isinstance(updates['coordinates'], list) and len(updates['coordinates']) == 2:
            updates['coordinates'] = GeoPoint(updates['coordinates'][0], updates['coordinates'][1])

        doc_ref.update(updates)
        return True
    except Exception as e:
        print(f"Error updating incident in Firestore: {e}")
        return False

def update_incident_status_in_firestore(incident_id, new_status):
    """Updates the status of an existing incident in Firestore."""
    try:
        doc_ref = db.collection('incidents').document(incident_id)
        doc_ref.update({'status': new_status})
        return True
    except Exception as e:
        print(f"Error updating incident status in Firestore: {e}")
        return False

def get_incident_from_firestore(incident_id):
    """Retrieves an incident from Firestore."""
    try:
        doc_ref = db.collection('incidents').document(incident_id)
        doc = doc_ref.get()
        if doc.exists:
            return doc.to_dict()
        else:
            return None
    except Exception as e:
        print(f"Error getting incident from Firestore: {e}")
        return None

def delete_incident_from_firestore(incident_id):
    """Deletes an incident from Firestore."""
    try:
        db.collection('incidents').document(incident_id).delete()
        return True
    except Exception as e:
        print(f"Error deleting incident from Firestore: {e}")
        return False
