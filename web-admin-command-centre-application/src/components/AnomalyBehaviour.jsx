import React from 'react';
import './AnomalyBehaviour.css';

const anomalies = [
  { id: 1, desc: 'Suspicious loitering in Zone 3', time: '10:50 AM', clip: 'https://www.w3schools.com/html/mov_bbb.mp4' },
  { id: 2, desc: 'Odd movement in Zone 1', time: '11:05 AM', clip: 'https://www.w3schools.com/html/movie.mp4' },
];

export default function AnomalyBehaviour() {
  return (
    <div className="anomaly-section">
      <h2>Anomaly Behaviour</h2>
      <div className="anomaly-list">
        {anomalies.map(a => (
          <div key={a.id} className="anomaly-card">
            <div><b>{a.desc}</b> <span>({a.time})</span></div>
            <video width="320" height="180" controls>
              <source src={a.clip} type="video/mp4" />
              Your browser does not support the video tag.
            </video>
          </div>
        ))}
      </div>
    </div>
  );
}
