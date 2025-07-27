import os
import json
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.agents import initialize_agent, Tool
from langchain_community.agent_toolkits.load_tools import load_tools
from tools import FindNearestUnitTool, ReadLocationsTool
from firebase_utils import add_incident_to_firestore
import google.generativeai as genai
from typing import TypedDict, Annotated, List
from langchain_core.runnables import RunnablePassthrough
from langgraph.graph import StateGraph

# Define the state for the LangGraph agent
class AgentState(TypedDict):
    incident_data: dict
    tool_output: str
    nearest_unit: dict

# Initialize the language model
# Get the client from the initialized genai
client = genai.GenerativeModel(model_name="gemini-2.5-flash")
# llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", temperature=0, client=client)
llm = ChatGoogleGenerativeAI(
    model="gemini-pro",
    temperature=0,
    client=client  # ✅ REQUIRED
)

# Define the tools the agent will use
tools = [
    FindNearestUnitTool(),
    ReadLocationsTool(),
    Tool(
        name="SaveIncident",
        func=add_incident_to_firestore,
        description="Saves the incident details including the assigned unit to the database. Input should be a JSON string."
    )
]

# Define the LangGraph workflow
workflow = StateGraph(AgentState)

# Add nodes to the workflow
def find_and_update_unit(state):
    incident_data = state["incident_data"]
    nearest_unit_tool = FindNearestUnitTool()
    nearest_unit_output = nearest_unit_tool.run(json.dumps(incident_data))
    
    # Assuming the tool output is a JSON string representing the nearest unit
    nearest_unit = json.loads(nearest_unit_output)
    
    # Update incident_data with dispatch info and status
    incident_data["dispatch_info"] = nearest_unit
    incident_data["status"] = "received"
    
    return {"incident_data": incident_data, "nearest_unit": nearest_unit, "tool_output": nearest_unit_output}

workflow.add_node("find_unit", find_and_update_unit)
workflow.add_node("add_incident_to_firestore", lambda state: {"tool_output": tools[2].run(json.dumps(state["incident_data"]))})

# Set the entry point of the workflow
workflow.set_entry_point("find_unit")

# Add edges
workflow.add_edge("find_unit", "add_incident_to_firestore")

# Compile the graph
app_graph = workflow.compile()

# The handle_incident function will now invoke the graph
def handle_incident(incident_details):
    initial_state = AgentState(incident_data=incident_details)
    final_state = app_graph.invoke(initial_state)
    return final_state

if __name__ == '__main__':
    # Example usage:
    incident = {
        "incident_type": "fire",
        "incident_location": [34.0522, -118.2437], # Example coordinates (Los Angeles)
        "description": "Building fire on Main St."
    }
    handle_incident(incident)
