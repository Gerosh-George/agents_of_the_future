// Helper to format coordinates as "25.36° N, 98.36° E"
function formatCoordinates(coords) {
  if (!coords) return '';
  // Firestore GeoPoint: {latitude, longitude}
  if (typeof coords.latitude === 'number' && typeof coords.longitude === 'number') {
    const lat = Math.abs(coords.latitude).toFixed(2) + '° ' + (coords.latitude >= 0 ? 'N' : 'S');
    const lng = Math.abs(coords.longitude).toFixed(2) + '° ' + (coords.longitude >= 0 ? 'E' : 'W');
    return lat + ', ' + lng;
  }
  // If array: [lat, lng]
  if (Array.isArray(coords) && coords.length === 2) {
    const lat = Math.abs(coords[0]).toFixed(2) + '° ' + (coords[0] >= 0 ? 'N' : 'S');
    const lng = Math.abs(coords[1]).toFixed(2) + '° ' + (coords[1] >= 0 ? 'E' : 'W');
    return lat + ', ' + lng;
  }
  // If string, just return
  if (typeof coords === 'string') return coords;
  return '';
}
import React, { useEffect, useState } from 'react';
import './IncidentDashboard.css';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs } from 'firebase/firestore';
import { Oval } from 'react-loader-spinner';

// Firebase config for project-drishti-hackathon
const firebaseConfig = {
  authDomain: "project-drishti-hackathon.firebaseapp.com",
  apiKey: 'AIzaSyAiJScwBucHls4ntnVWHJgV8sMX6kAb4GY',
  appId: '1:39709458518:android:99247aed7241e322743bf7',
  messagingSenderId: '39709458518',
  projectId: 'project-drishti-hackathon',
  storageBucket: 'project-drishti-hackathon.firebasestorage.app',
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);

export default function IncidentDashboard() {
  const [incidents, setIncidents] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function fetchIncidents() {
      setLoading(true); // Ensure loader is shown before fetching
      try {
        const querySnapshot = await getDocs(collection(db, 'incidents'));
        const data = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
        setIncidents(data);
      } catch (error) {
        console.error('Error fetching incidents:', error);
      } finally {
        setLoading(false); // Ensure loader is hidden after fetching
      }
    }

    fetchIncidents();

    const interval = setInterval(() => {
      fetchIncidents();
    }, 5000); // Fetch data every 5 seconds

    return () => clearInterval(interval); // Cleanup interval on component unmount
  }, []);

  const receivedIncidents = incidents.filter(inc => inc.status?.toLowerCase() === 'received');
  const inProgressIncidents = incidents.filter(inc => inc.status?.toLowerCase() === 'inprogress');
  const doneIncidents = incidents.filter(inc => inc.status?.toLowerCase() === 'done');

  return (
    <div className="incident-dashboard">
      <h2>Incident Monitoring</h2>
      {loading ? (
        <div className="loader-spinner">
          <Oval
            height={80}
            width={80}
            color="#4fa94d"
            wrapperStyle={{}}
            wrapperClass=""
            visible={true}
            ariaLabel="oval-loading"
            secondaryColor="#4fa94d"
            strokeWidth={2}
            strokeWidthSecondary={2}
          />
        </div>
      ) : (
        <>
          <div className="incidents-table-section">
            <div className="incidents-table-title received">Received Incidents</div>
            <table className="incidents-table">
              <thead>
                <tr>
                  <th>Type</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Coordinates</th>
                  <th>Time</th>
                </tr>
              </thead>
              <tbody>
                {receivedIncidents.length === 0 ? (
                  <tr><td colSpan={5} style={{textAlign:'center'}}>No received incidents</td></tr>
                ) : receivedIncidents.map(inc => (
                  <tr key={inc.id} className={inc.status?.replace(' ', '-').toLowerCase()}>
                    <td>{inc.incident_type}</td>
                    <td>{inc.description}</td>
                    <td>{inc.status}</td>
                    <td>{formatCoordinates(inc.coordinates)}</td>
                    <td>{inc.timestamp ? new Date(inc.timestamp).toLocaleString() : ''}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="incidents-table-section">
            <div className="incidents-table-title inprogress">In Progress Incidents</div>
            <table className="incidents-table">
              <thead>
                <tr>
                  <th>Type</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Coordinates</th>
                  <th>Time</th>
                </tr>
              </thead>
              <tbody>
                {inProgressIncidents.length === 0 ? (
                  <tr><td colSpan={5} style={{textAlign:'center'}}>No in-progress incidents</td></tr>
                ) : inProgressIncidents.map(inc => (
                  <tr key={inc.id} className={inc.status?.replace(' ', '-').toLowerCase()}>
                    <td>{inc.incident_type}</td>
                    <td>{inc.description}</td>
                    <td>{inc.status}</td>
                    <td>{formatCoordinates(inc.coordinates)}</td>
                    <td>{inc.timestamp ? new Date(inc.timestamp).toLocaleString() : ''}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          <div className="incidents-table-section">
            <div className="incidents-table-title done">Done Incidents</div>
            <table className="incidents-table">
              <thead>
                <tr>
                  <th>Type</th>
                  <th>Description</th>
                  <th>Status</th>
                  <th>Coordinates</th>
                  <th>Time</th>
                </tr>
              </thead>
              <tbody>
                {doneIncidents.length === 0 ? (
                  <tr><td colSpan={5} style={{textAlign:'center'}}>No done incidents</td></tr>
                ) : doneIncidents.map(inc => (
                  <tr key={inc.id} className={inc.status?.replace(' ', '-').toLowerCase()}>
                    <td>{inc.incident_type}</td>
                    <td>{inc.description}</td>
                    <td>{inc.status}</td>
                    <td>{formatCoordinates(inc.coordinates)}</td>
                    <td>{inc.timestamp ? new Date(inc.timestamp).toLocaleString() : ''}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </>
      )}
    </div>
  );
}
