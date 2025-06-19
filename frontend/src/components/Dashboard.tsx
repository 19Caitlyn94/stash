import { useState, useEffect } from 'react';
import { useDropzone } from 'react-dropzone';
import { useAuth } from '../hooks/useAuth';
import { fileApi } from '../services/api';
import type { FileItem } from '../types';
import { useNavigate } from 'react-router-dom';
import stashLogo from '../assets/stash_logo.png';

const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'image/gif', 'image/svg+xml', 'text/plain', 'text/markdown', 'text/csv'];
const MAX_FILE_SIZE = 2 * 1024 * 1024; // 2MB

export function Dashboard() {
  const { user, logout, loading: authLoading } = useAuth();
  const [files, setFiles] = useState<FileItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [uploading, setUploading] = useState(false);
  const [error, setError] = useState('');
  const [activity, setActivity] = useState<any[]>([]);
  const [activityLoading, setActivityLoading] = useState(true);
  const navigate = useNavigate();
  const [darkMode, setDarkMode] = useState(() => {
    if (typeof window !== 'undefined') {
      return localStorage.getItem('darkMode') === 'true';
    }
    return false;
  });

  useEffect(() => {
    if (!user && !authLoading) {
      navigate('/', { replace: true });
      return;
    }
    if (user) {
      loadFiles();
      loadActivity();
    }
  }, [user, authLoading]);

  useEffect(() => {
    document.body.classList.toggle('dark', darkMode);
    localStorage.setItem('darkMode', darkMode ? 'true' : 'false');
  }, [darkMode]);

  const loadFiles = async () => {
    try {
      const fileList = await fileApi.list();
      setFiles(fileList);
    } catch (err) {
      setError('Failed to load files');
    } finally {
      setLoading(false);
    }
  };

  const loadActivity = async () => {
    setActivityLoading(true);
    try {
      const activityList = await fileApi.getUploadActivity();
      setActivity(activityList);
    } catch (err) {
      setActivity([]);
    } finally {
      setActivityLoading(false);
    }
  };

  const onDrop = async (acceptedFiles: File[]) => {
    const file = acceptedFiles[0];
    if (!file) return;

    // Validate file type
    if (!ALLOWED_TYPES.includes(file.type)) {
      setError('File type not supported. Allowed: JPG, PNG, GIF, SVG, TXT, MD, CSV');
      return;
    }

    // Validate file size
    if (file.size > MAX_FILE_SIZE) {
      setError('File too large. Maximum size is 2MB');
      return;
    }

    setUploading(true);
    setError('');

    try {
      const uploadedFile = await fileApi.upload(file);
      setFiles(prev => [uploadedFile, ...prev]);
    } catch (err: any) {
      if (typeof err.message === 'string' && err.message.includes('Unsupported file type')) {
        setError('The file type you selected is not supported. Please upload a JPG, PNG, GIF, SVG, TXT, MD, or CSV file.');
      } else if (typeof err.message === 'string') {
        setError(`Upload failed: ${err.message}`);
      } else {
        setError('Upload failed. Please try again.');
      }
    } finally {
      setUploading(false);
    }
  };

  const { getRootProps, getInputProps, isDragActive } = useDropzone({
    onDrop,
    maxFiles: 1,
    accept: {
      'image/*': ['.jpeg', '.jpg', '.png', '.gif', '.svg'],
      'text/*': ['.txt', '.md', '.csv']
    }
  });

  const handleDownload = async (file: FileItem) => {
    try {
      const blob = await fileApi.download(file.id);
      const url = URL.createObjectURL(blob);
      const a = document.createElement('a');
      a.href = url;
      a.download = file.filename;
      document.body.appendChild(a);
      a.click();
      document.body.removeChild(a);
      URL.revokeObjectURL(url);
    } catch (err) {
      setError('Download failed');
    }
  };

  const formatFileSize = (bytes: number) => {
    if (bytes === 0) return '0 Bytes';
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
  };

  const formatDate = (dateString: string) => {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    });
  };

  if (authLoading || loading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner"></div>
        <p>Loading...</p>
      </div>
    );
  }

  return (
    <div className="dashboard-main">
      <header className="dashboard-header">
        <div className="logo-container">
          <img src={stashLogo} alt="Stash" className="stash-logo" style={{ filter: darkMode ? 'invert(1) hue-rotate(180deg)' : 'none', transition: 'filter 0.3s' }} />
        </div>
        <div className="user-info">
          <span>Welcome, {user?.email_address}</span>
          <button onClick={logout} className="btn-secondary">
            Sign out
          </button>
          <button
            onClick={() => setDarkMode((d) => !d)}
            className="btn-secondary"
            style={{ marginLeft: '1rem' }}
            aria-label="Toggle dark mode"
          >
            {darkMode ? '☀️' : '🌙'}
          </button>
        </div>
      </header>

      {error && (
        <div className="error-message">
          {error}
        </div>
      )}

      <div className="upload-section">
        <div 
          {...getRootProps()} 
          className={`dropzone ${isDragActive ? 'active' : ''} ${uploading ? 'uploading' : ''}`}
        >
          <input {...getInputProps()} />
          {uploading ? (
            <p>Uploading...</p>
          ) : isDragActive ? (
            <p>Drop the file here...</p>
          ) : (
            <div>
              <p>Drag & drop a file here, or click to select</p>
              <p className="file-info">
                Supported: JPG, PNG, GIF, SVG, TXT, MD, CSV (max 2MB)
              </p>
            </div>
          )}
        </div>
      </div>

      <div className="files-section">
        <h2>Your Files ({files.length})</h2>
        {loading ? (
          <p>Loading files...</p>
        ) : files.length === 0 ? (
          <p className="no-files">No files yet. Upload your first file above!</p>
        ) : (
          <div className="files-grid">
            {files.map((file) => (
              <div key={file.id} className="file-card">
                <div className="file-icon">
                  {file.content_type.startsWith('image/') ? '🖼️' : '📄'}
                </div>
                <div className="file-info">
                  <h3 className="file-name">{file.filename}</h3>
                  <p className="file-meta">
                    {formatFileSize(file.file_size)} • {formatDate(file.created_at)}
                  </p>
                  <p className="file-type">{file.content_type}</p>
                </div>
                <button 
                  onClick={() => handleDownload(file)}
                  className="btn-download"
                >
                  Download
                </button>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
} 
