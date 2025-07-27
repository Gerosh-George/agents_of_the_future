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
import './Alerts.css';
import { initializeApp } from 'firebase/app';
import { getFirestore, collection, getDocs, addDoc, serverTimestamp, GeoPoint } from 'firebase/firestore';

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

export default function Alerts() {
  const [alerts, setAlerts] = useState([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [form, setForm] = useState({
    coordinates: '',
    message: '',
    severity: 'High',
    timestamp: '',
  });
  const [submitting, setSubmitting] = useState(false);

  useEffect(() => {
    async function fetchAlerts() {
      setLoading(true);
      const querySnapshot = await getDocs(collection(db, 'alerts'));
      const data = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
      setAlerts(data);
      setLoading(false);
    }
    fetchAlerts();
  }, []);

  const highAlerts = alerts.filter(a => a.severity?.toLowerCase() === 'high');
  const mediumAlerts = alerts.filter(a => a.severity?.toLowerCase() === 'medium');
  const lowAlerts = alerts.filter(a => a.severity?.toLowerCase() === 'low');

  async function handleAddAlert(e) {
    e.preventDefault();
    setSubmitting(true);
    let coords = form.coordinates;
    // Parse coordinates string like "12.35° N, 35.68° E" to {latitude, longitude}
    const match = coords.match(/([0-9.]+)°\s*([NS]),\s*([0-9.]+)°\s*([EW])/i);
    let coordinates = coords;
    if (match) {
      const lat = parseFloat(match[1]) * (match[2].toUpperCase() === 'N' ? 1 : -1);
      const lng = parseFloat(match[3]) * (match[4].toUpperCase() === 'E' ? 1 : -1);
      coordinates = new GeoPoint(lat, lng); // Use Firestore GeoPoint
    }
    // Set timestamp to current time
    const timestamp = new Date();

    await addDoc(collection(db, 'alerts'), {
      coordinates,
      message: form.message,
      severity: form.severity,
      status: 'Open', // Default status
      timestamp,
    });
    setShowModal(false);
    setForm({
      coordinates: '',
      message: '',
      severity: 'High',
      timestamp: '',
    });
    setSubmitting(false);
    // Refresh alerts
    const querySnapshot = await getDocs(collection(db, 'alerts'));
    const data = querySnapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    setAlerts(data);
  }

  return (
    <div className="incident-dashboard">
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
        <h2>Alerts</h2>
        <button
          style={{
            padding: '8px 16px',
            background: '#1976d2',
            color: '#fff',
            border: 'none',
            borderRadius: 4,
            cursor: 'pointer',
            fontWeight: 600,
            fontSize: 16,
          }}
          onClick={() => setShowModal(true)}
        >
          Add
        </button>
      </div>
      {/* Modal for adding alert */}
      {showModal && (
        <div
          style={{
            position: 'fixed',
            top: 0, left: 0, right: 0, bottom: 0,
            background: 'rgba(0,0,0,0.3)',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            zIndex: 1000,
          }}
        >
          <form
            style={{
              background: '#fff',
              padding: 24,
              borderRadius: 8,
              minWidth: 320,
              boxShadow: '0 2px 16px rgba(0,0,0,0.15)',
              display: 'flex',
              flexDirection: 'column',
              gap: 16,
            }}
            onSubmit={handleAddAlert}
          >
            <h3>Add Alert</h3>
            <label>
              Coordinates<br />
              <input
                type="text"
                required
                placeholder='e.g. 12.35° N, 35.68° E'
                value={form.coordinates}
                onChange={e => setForm(f => ({ ...f, coordinates: e.target.value }))}
                style={{ width: '100%' }}
              />
            </label>
            <label>
              Message<br />
              <input
                type="text"
                required
                placeholder='Alert message'
                value={form.message}
                onChange={e => setForm(f => ({ ...f, message: e.target.value }))}
                style={{ width: '100%' }}
              />
            </label>
            <label>
              Severity<br />
              <select
                value={form.severity}
                onChange={e => setForm(f => ({ ...f, severity: e.target.value }))}
                style={{ width: '100%' }}
              >
                <option>High</option>
                <option>Medium</option>
                <option>Low</option>
              </select>
            </label>
            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: 8 }}>
              <button
                type="button"
                onClick={() => setShowModal(false)}
                style={{
                  background: '#eee',
                  color: '#333',
                  border: 'none',
                  borderRadius: 4,
                  padding: '6px 14px',
                  cursor: 'pointer',
                }}
                disabled={submitting}
              >
                Cancel
              </button>
              <button
                type="submit"
                style={{
                  background: '#1976d2',
                  color: '#fff',
                  border: 'none',
                  borderRadius: 4,
                  padding: '6px 14px',
                  cursor: 'pointer',
                  fontWeight: 600,
                }}
                disabled={submitting}
              >
                {submitting ? 'Adding...' : 'Add Alert'}
              </button>
            </div>
          </form>
        </div>
      )}
      {loading ? (
        <div>Loading...</div>
      ) : (
        <>
          <div className="alerts-table-section">
            <div className="alerts-table-title high">High Severity</div>
            <table className="alerts-table">
              <thead>
                <tr>
                  <th>Message</th>
                  <th>Status</th>
                  <th>Coordinates</th>
                  <th>Time</th>
                </tr>
              </thead>
              <tbody>
                {highAlerts.length === 0 ? (
                  <tr><td colSpan={5} style={{textAlign:'center'}}>No high severity alerts</td></tr>
                ) : highAlerts.map(alert => (
                  <tr key={alert.id}>
                    <td>{alert.message}</td>
                    <td>{alert.status}</td>
                    <td>{formatCoordinates(alert.coordinates)}</td>
                    <td>{alert.timestamp ? new Date(alert.timestamp.seconds ? alert.timestamp.seconds * 1000 : alert.timestamp).toLocaleString() : ''}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="alerts-table-section">
            <div className="alerts-table-title medium">Medium Severity</div>
            <table className="alerts-table">
              <thead>
                <tr>
                  <th>Message</th>
                  <th>Status</th>
                  <th>Coordinates</th>
                  <th>Time</th>
                </tr>
              </thead>
              <tbody>
                {mediumAlerts.length === 0 ? (
                  <tr><td colSpan={5} style={{textAlign:'center'}}>No medium severity alerts</td></tr>
                ) : mediumAlerts.map(alert => (
                  <tr key={alert.id}>
                    <td>{alert.message}</td>
                    <td>{alert.status}</td>
                    <td>{formatCoordinates(alert.coordinates)}</td>
                    <td>{alert.timestamp ? new Date(alert.timestamp.seconds ? alert.timestamp.seconds * 1000 : alert.timestamp).toLocaleString() : ''}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <div className="alerts-table-section">
            <div className="alerts-table-title low">Low Severity</div>
            <table className="alerts-table">
              <thead>
                <tr>
                  <th>Message</th>
                  <th>Status</th>
                  <th>Coordinates</th>
                  <th>Time</th>
                </tr>
              </thead>
              <tbody>
                {lowAlerts.length === 0 ? (
                  <tr><td colSpan={5} style={{textAlign:'center'}}>No low severity alerts</td></tr>
                ) : lowAlerts.map(alert => (
                  <tr key={alert.id}>
                    <td>{alert.message}</td>
                    <td>{alert.status}</td>
                    <td>{formatCoordinates(alert.coordinates)}</td>
                    <td>{alert.timestamp ? new Date(alert.timestamp.seconds ? alert.timestamp.seconds * 1000 : alert.timestamp).toLocaleString() : ''}</td>
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
