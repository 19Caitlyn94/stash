import { useState } from 'react'
import { AuthProvider, useAuth } from './hooks/useAuth'
import { Login } from './components/Login'
import { Signup } from './components/Signup'
import { Dashboard } from './components/Dashboard'
import './App.css'

function AuthWrapper() {
  const { user, loading } = useAuth()
  const [isLogin, setIsLogin] = useState(true)

  if (loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>Loading...</p>
      </div>
    )
  }

  if (user) {
    return <Dashboard />
  }

  return isLogin ? (
    <Login onToggleMode={() => setIsLogin(false)} />
  ) : (
    <Signup onToggleMode={() => setIsLogin(true)} />
  )
}

function App() {
  return (
    <AuthProvider>
      <div className="app">
        <AuthWrapper />
      </div>
    </AuthProvider>
  )
}

export default App
