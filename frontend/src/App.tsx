import { useState } from 'react'
import { AuthProvider, useAuth } from './hooks/useAuth'
import { Login } from './components/Login'
import { Signup } from './components/Signup'
import { Dashboard } from './components/Dashboard'
import { Landing } from './components/Landing'
import './App.css'
import { BrowserRouter, Routes, Route, Navigate, useLocation } from 'react-router-dom'

function AuthWrapper({ initialMode }: { initialMode: 'login' | 'signup' }) {
  const { user, loading } = useAuth();
  const [isLogin, setIsLogin] = useState(initialMode === 'login');
  const location = useLocation();

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>Loading...</p>
      </div>
    );
  }

  if (user) {
    // If already logged in, redirect to dashboard
    return <Navigate to="/dashboard" state={{ from: location }} replace />;
  }

  return isLogin ? (
    <Login onToggleMode={() => setIsLogin(false)} />
  ) : (
    <Signup onToggleMode={() => setIsLogin(true)} />
  );
}

function App() {
  return (
    <AuthProvider>
      <BrowserRouter>
        <div className="app">
          <Routes>
            <Route path="/" element={<Landing />} />
            <Route path="/login" element={<AuthWrapper initialMode="login" />} />
            <Route path="/signup" element={<AuthWrapper initialMode="signup" />} />
            <Route path="/dashboard" element={<Dashboard />} />
            <Route path="*" element={<Navigate to="/" />} />
          </Routes>
        </div>
      </BrowserRouter>
    </AuthProvider>
  )
}

export default App
