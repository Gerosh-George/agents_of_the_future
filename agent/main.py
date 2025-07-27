from flask import Flask, request, jsonify
import google.generativeai as genai
from langchain_google_genai import ChatGoogleGenerativeAI
from firebase_utils import add_incident_to_firestore  # Import the function
import os
from agent import app_graph, AgentState # Import the LangGraph agent and state
import json
from pydantic import BaseModel # Updated to Pydantic v2
from incidents import incidents_bp

# Initialize Flask app
app = Flask(__name__)
app.register_blueprint(incidents_bp)


# Configure API key (either set it in env or pass directly)
genai.configure(api_key=os.environ.get("GOOGLE_API_KEY"))

# Initialize Gemini model
llm = ChatGoogleGenerativeAI(
    model="gemini-pro",
    temperature=0.7
)

@app.route('/')
def home():
    return "Incident Management Agent is running!"

# Use POST method for handling incidents
@app.route('/handle_incident', methods=['POST'])
def handle_incident():
    data = request.json
    incident_type = data.get('incident_type')
    description = data.get('description')
    timestamp = data.get('timestamp')
    coordinates = data.get('coordinates')

    if not all([incident_type, description, timestamp, coordinates]):
        return jsonify({"error": "Missing incident data"}), 400

    # Add status with initial value 'received'
    status = 'received'

    # Prepare initial state for the LangGraph agent
    initial_state = AgentState(incident_data={
        'timestamp': timestamp,
        'incident_type': incident_type,
        'description': description,
        'coordinates': coordinates,
        'status': status
    })

    try:
        # Run the LangGraph agent
        # The graph will execute the defined nodes in sequence
        final_state = app_graph.invoke(initial_state)

        # Extract the results from the final state
        dispatch_info = final_state.dispatch_info

        # Create incident data dictionary including the final dispatch info
        incident_data_to_store = {
            'timestamp': timestamp,
            'incident_type': incident_type,
            'description': description,
            'coordinates': coordinates,
            'status': status,
            'action': dispatch_info  # Add the final dispatch info
        }

        # Store the incident data in Firestore
        incident_id = add_incident_to_firestore(incident_data_to_store)

        return jsonify({"message": "Incident processed and stored", "incident_id": incident_id, "dispatch_info": dispatch_info}), 200

    except Exception as e:
        # Log the error for debugging
        print(f"Error processing incident: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    # In production, use a production-ready WSGI server like Gunicorn or uWSGI.
    # For local development, you can use app.run()
    # To run with the devserver.sh script in Firebase Studio, you don't need app.run()
    app.run(debug=True, port=int(os.environ.get("PORT", 8080)))
