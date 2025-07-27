from langchain.tools import BaseTool
import json
from geopy.distance import geodesic
from pydantic import Field
from langchain_google_genai import ChatGoogleGenerativeAI

class ReadLocationsTool(BaseTool):
    name: str = "ReadLocationsTool"
    description: str = "Reads the locations.json file and returns its content."

    def _run(self, query: str):
        with open('locations.json', 'r') as f:
            return f.read()

    def _aembeddings(self, query: str):
        raise NotImplementedError("This tool does not support async")

class FindNearestUnitTool(BaseTool):
    name: str = "FindNearestUnitTool"
    description: str = "Finds the nearest unit based on incident location and type from the provided locations data. Input should be a JSON string containing 'incident_location' (latitude, longitude) and 'incident_type'."

    def _run(self, query: str):
        try:
            query_data = json.loads(query)
            incident_location = tuple(query_data['incident_location'])
            incident_type = query_data['incident_type']

            with open('locations.json', 'r') as f:
                locations_data = json.load(f)

            nearest_unit = None
            min_distance = float('inf')

            for unit_type, units in locations_data.items():
                if unit_type.lower() == incident_type.lower():
                    for unit_name, unit_location in units.items():
                        distance = geodesic(incident_location, tuple(unit_location)).km
                        if distance < min_distance:
                            min_distance = distance
                            nearest_unit = {"unit_name": unit_name, "unit_location": unit_location, "unit_type": unit_type}

            return json.dumps(nearest_unit) if nearest_unit else json.dumps({"nearest_unit": None})

        except Exception as e:
            return json.dumps({"error": str(e)})

    def _aembeddings(self, query: str):
        raise NotImplementedError("This tool does not support async")
