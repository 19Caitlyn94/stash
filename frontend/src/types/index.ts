export interface User {
  id: number;
  email_address: string;
  created_at: string;
}

export interface FileItem {
  id: number;
  filename: string;
  content_type: string;
  file_size: number;
  created_at: string;
}

export interface AuthResponse {
  user: User;
  message?: string;
}

export interface LoginData {
  email_address: string;
  password: string;
}

export interface SignupData {
  email_address: string;
  password: string;
  password_confirmation: string;
} 