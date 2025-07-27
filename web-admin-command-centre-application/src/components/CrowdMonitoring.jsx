import React, { useState } from 'react';
import './CrowdMonitoring.css';

const mockZones = [
  { id: 1, name: 'Zone 1', density: 90, velocity: 1.2, coords: 'A1', isCritical: true },
  { id: 2, name: 'Zone 2', density: 40, velocity: 0.8, coords: 'B2', isCritical: false },
  { id: 3, name: 'Zone 3', density: 75, velocity: 1.5, coords: 'C3', isCritical: true },
  { id: 4, name: 'Zone 4', density: 20, velocity: 0.5, coords: 'D4', isCritical: false },
];
const helpers = [
  { id: 1, name: 'Support Staff 1' },
  { id: 2, name: 'Support Staff 2' },
  { id: 3, name: 'Support Staff 3' },
];

export default function CrowdMonitoring() {
  const [selectedZone, setSelectedZone] = useState(null);
  const [selectedHelper, setSelectedHelper] = useState(null);
  const [futureAlert, setFutureAlert] = useState({ zone: 'Zone 3', time: '30 mins', plan: false });

  return (
    <div className="crowd-monitoring">
      <h2>Crowd Monitoring & Insights</h2>
      <div className="zones">
        {mockZones.map(zone => (
          <div
            key={zone.id}
            className={`zone-card${zone.isCritical ? ' critical' : ''}`}
            onClick={() => setSelectedZone(zone)}
          >
            <div className="zone-title">{zone.name} ({zone.coords})</div>
            <div>Density: <b>{zone.density}</b></div>
            <div>Velocity: <b>{zone.velocity}</b></div>
          </div>
        ))}
      </div>
      {selectedZone && (
        <div className="zone-details">
          <h3>Assist in {selectedZone.name}</h3>
          <div>Select a person to help:</div>
          <select onChange={e => setSelectedHelper(e.target.value)} value={selectedHelper || ''}>
            <option value="">Select Support Staff</option>
            {helpers.map(h => (
              <option key={h.id} value={h.name}>{h.name}</option>
            ))}
          </select>
          {selectedHelper && <div>Assigned <b>{selectedHelper}</b> to {selectedZone.name}</div>}
        </div>
      )}
      <div className="future-prediction">
        <h3>Future Prediction</h3>
        <div>Possible chaos in <b>{futureAlert.zone}</b> in next <b>{futureAlert.time}</b></div>
        <button className="plan-btn" onClick={() => setFutureAlert({ ...futureAlert, plan: true })}>
          Plan to Resolve
        </button>
        {futureAlert.plan && <div className="plan-action">Plan initiated for {futureAlert.zone}</div>}
      </div>
    </div>
  );
}
