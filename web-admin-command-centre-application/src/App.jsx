

import './App.css';
import { useState } from 'react';

import Dashboard from './components/Dashboard';
import CrowdMonitoring from './components/CrowdMonitoring';
import Alerts from './components/Alerts';
import IncidentDashboard from './components/IncidentDashboard';
import AnomalyBehaviour from './components/AnomalyBehaviour';
import QuickPlaces from './components/QuickPlaces';
import logo from './assets/logo.jpg';

const TABS = [
  { key: 'dashboard', label: 'Dashboard' },
  { key: 'crowd', label: 'Crowd Monitoring' },
  { key: 'alerts', label: 'Alerts' },
  { key: 'incidents', label: 'Incident Monitoring' },
  { key: 'anomaly', label: 'Anomaly Behaviour' },
  { key: 'quickplaces', label: 'Quick Places' },
];


function App() {
  const [tab, setTab] = useState('dashboard');

  const renderTab = () => {
    switch (tab) {
      case 'dashboard':
        return <Dashboard onNavigate={setTab} />;
      case 'crowd':
        return <CrowdMonitoring />;
      case 'alerts':
        return <Alerts />;
      case 'incidents':
        return <IncidentDashboard />;
      case 'anomaly':
        return <AnomalyBehaviour />;
      case 'quickplaces':
        return <QuickPlaces />;
      default:
        return null;
    }
  };

  return (
    <div className="admin-dashboard">
      <header className="dashboard-header">
        <div className="logo-row vertical-logo-row" style={{flexDirection: 'column', gap: 0}}>
          <img src={logo} alt="Dhristi Logo" className="dhristi-logo" />
          <span className="logo-title" style={{marginTop: 8}}>Command Center</span>
        </div>
        <div className="dashboard-subtitle">Admin Dashboard for Real-Time Monitoring & Insights</div>
        <nav className="dashboard-tabs">
          {TABS.map(t => (
            <button
              key={t.key}
              className={`tab-btn${tab === t.key ? ' active' : ''}`}
              onClick={() => setTab(t.key)}
            >
              {t.label}
            </button>
          ))}
        </nav>
      </header>
      <main>
        <div className="dashboard-container uniform-section">
          {renderTab()}
        </div>
      </main>
      <footer className="dashboard-footer">
        &copy; {new Date().getFullYear()} Dhristi Command Center
      </footer>
    </div>
  );
}

export default App;
