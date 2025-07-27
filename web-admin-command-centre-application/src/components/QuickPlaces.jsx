import React, { useState } from 'react';
import './QuickPlaces.css';

export default function QuickPlaces() {
  const [places, setPlaces] = useState([]);
  const [form, setForm] = useState({ name: '', lat: '', lng: '' });

  const handleChange = e => {
    setForm({ ...form, [e.target.name]: e.target.value });
  };

  const handleAdd = e => {
    e.preventDefault();
    if (!form.name || !form.lat || !form.lng) return;
    setPlaces([...places, { ...form }]);
    setForm({ name: '', lat: '', lng: '' });
  };

  return (
    <div className="quick-places-section">
      <h2>Quick Places</h2>
      <form className="quick-places-form" onSubmit={handleAdd}>
        <input
          type="text"
          name="name"
          placeholder="Name"
          value={form.name}
          onChange={handleChange}
          required
        />
        <input
          type="number"
          name="lat"
          placeholder="Latitude"
          value={form.lat}
          onChange={handleChange}
          step="any"
          required
        />
        <input
          type="number"
          name="lng"
          placeholder="Longitude"
          value={form.lng}
          onChange={handleChange}
          step="any"
          required
        />
        <button type="submit">Add Place</button>
      </form>
      <table className="quick-places-table">
        <thead>
          <tr>
            <th>Name</th>
            <th>Latitude</th>
            <th>Longitude</th>
          </tr>
        </thead>
        <tbody>
          {places.map((p, i) => (
            <tr key={i}>
              <td>{p.name}</td>
              <td>{p.lat}</td>
              <td>{p.lng}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}
