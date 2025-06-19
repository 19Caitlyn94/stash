import React from 'react';
import { useNavigate } from 'react-router-dom';
import './Landing.css';
import stashLogo from '../assets/stash_logo.png';

const features = [
  {
    icon: '🗂️',
    title: 'Organize Effortlessly',
    desc: 'Upload and manage your files in one secure place.'
  },
  {
    icon: '⚡',
    title: 'Instant Access',
    desc: 'Grab your files anytime, anywhere, lightning fast.'
  },
  {
    icon: '🔒',
    title: 'Private & Secure',
    desc: 'Your data is protected with top-notch security.'
  },
  {
    icon: '📤',
    title: 'Easy Uploads',
    desc: "Drag, drop, and you're done. Supports images, docs, and more."
  }
];

export function Landing() {
  const navigate = useNavigate();
  return (
    <div className="landing-container">
      <div className="landing-logo">
        <img src={stashLogo} alt="Stash" className="stash-logo-large" />
      </div>
      <h2 className="landing-subheading">Your personal file vault—simple, fast, and secure.</h2>
      <div className="landing-features">
        {features.map((f, i) => (
          <div className="feature-card" key={i}>
            <div className="feature-icon">{f.icon}</div>
            <div className="feature-title">{f.title}</div>
            <div className="feature-desc">{f.desc}</div>
          </div>
        ))}
      </div>
      <button className="landing-btn" onClick={() => navigate('/signup')}>Get Started</button>
    </div>
  );
} 
