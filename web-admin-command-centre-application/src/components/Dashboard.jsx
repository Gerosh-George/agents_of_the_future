import React from 'react';
import './Dashboard.css';

export default function Dashboard({ onNavigate }) {
  // Mock summary data
  const stats = {
    crowdCritical: 2,
    totalZones: 4,
    healthAlerts: 2,
    safetyAlerts: 2,
    fireAlerts: 1,
    incidents: 3,
    anomalies: 2,
  };

  return (
    <>
      <h2>Unified Analytics Dashboard</h2>
      <div className="dashboard-cards">
        <div className="dashboard-card" onClick={() => onNavigate('crowd')}>Crowd Critical Zones
          <div className="card-value critical">{stats.crowdCritical} / {stats.totalZones}</div>
        </div>
        <div className="dashboard-card" onClick={() => onNavigate('alerts')}>Health Alerts
          <div className="card-value health">{stats.healthAlerts}</div>
        </div>
        <div className="dashboard-card" onClick={() => onNavigate('alerts')}>Safety Alerts
          <div className="card-value safety">{stats.safetyAlerts}</div>
        </div>
        <div className="dashboard-card" onClick={() => onNavigate('alerts')}>Fire/Emergency
          <div className="card-value fire">{stats.fireAlerts}</div>
        </div>
        <div className="dashboard-card" onClick={() => onNavigate('incidents')}>Incidents
          <div className="card-value incidents">{stats.incidents}</div>
        </div>
        <div className="dashboard-card" onClick={() => onNavigate('anomaly')}>Anomalies
          <div className="card-value anomaly">{stats.anomalies}</div>
        </div>
      </div>
    </>
  );
}
