import type { User, AuthResponse, LoginData, SignupData, FileItem } from '../types';

const API_BASE_URL = 'http://localhost:3000';

// Configure axios-like fetch wrapper
async function apiRequest<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const url = `${API_BASE_URL}${endpoint}`;
  
  const config: RequestInit = {
    credentials: 'include', // Important for cookie-based auth
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...options.headers,
    },
    ...options,
  };

  const response = await fetch(url, config);
  
  if (!response.ok) {
    const errorData = await response.json().catch(() => ({}));
    throw new Error(errorData.error || errorData.errors?.join(', ') || 'Request failed');
  }

  // Handle empty responses
  const contentType = response.headers.get('content-type');
  if (contentType?.includes('application/json')) {
    return response.json();
  }
  
  return response as T;
}

// Authentication API
export const authApi = {
  async login(credentials: LoginData): Promise<User> {
    const response = await apiRequest<AuthResponse>('/session', {
      method: 'POST',
      body: JSON.stringify({
        email_address: credentials.email_address,
        password: credentials.password,
      }),
    });
    return response.user;
  },

  async signup(userData: SignupData): Promise<User> {
    const response = await apiRequest<AuthResponse>('/users', {
      method: 'POST',
      body: JSON.stringify({
        user: {
          email_address: userData.email_address,
          password: userData.password,
          password_confirmation: userData.password_confirmation,
        },
      }),
    });
    return response.user;
  },

  async logout(): Promise<void> {
    await apiRequest('/session', {
      method: 'DELETE',
    });
  },

  async checkAuth(): Promise<User> {
    // Since the backend doesn't have a specific check auth endpoint,
    // we'll try to get the current user info by making an authenticated request
    const response = await apiRequest<{ user: User }>('/session', {
      method: 'GET',
    });
    return response.user;
  },
};

// File management API
export const fileApi = {
  async list(): Promise<FileItem[]> {
    interface BackendFile {
      id: number;
      filename: string;
      content_type: string;
      file_size: number;
      created_at: string;
    }
    const response = await apiRequest<{ files: BackendFile[] }>('/files');
    
    // Transform the backend response to match our FileItem interface
    return response.files.map((file) => ({
      id: file.id,
      filename: file.filename,
      content_type: file.content_type,
      file_size: file.file_size,
      created_at: file.created_at,
    }));
  },

  async upload(file: File): Promise<FileItem> {
    const formData = new FormData();
    formData.append('file', file);

    const response = await fetch(`${API_BASE_URL}/uploads`, {
      method: 'POST',
      credentials: 'include',
      body: formData,
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      throw new Error(errorData.error || 'Upload failed');
    }

    const data = await response.json();
    return {
      id: data.id,
      filename: file.name,
      content_type: file.type,
      file_size: file.size,
      created_at: new Date().toISOString(),
    };
  },

  async download(fileId: number): Promise<Blob> {
    const response = await fetch(`${API_BASE_URL}/files/${fileId}?download=true`, {
      method: 'GET',
      credentials: 'include',
    });

    if (!response.ok) {
      throw new Error('Download failed');
    }

    return response.blob();
  },

  // Helper method to determine content type from filename
  getContentType(filename: string): string {
    const extension = filename.toLowerCase().split('.').pop();
    const mimeTypes: Record<string, string> = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'svg': 'image/svg+xml',
      'txt': 'text/plain',
      'md': 'text/markdown',
      'csv': 'text/csv',
    };
    return mimeTypes[extension || ''] || 'application/octet-stream';
  },

  async getUploadActivity(): Promise<any[]> {
    const response = await apiRequest<{ activities: any[] }>('/uploads');
    return response.activities;
  },
};

// Export all APIs
export default {
  auth: authApi,
  files: fileApi,
};
