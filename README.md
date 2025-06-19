# 📦 Stash File Management App

A full-stack application for secure file upload, listing, download, and preview, built with **Rails 8 (API-only, PostgreSQL)** and **React + TypeScript + Vite**.

---

## 🚀 Features

- User authentication (login/signup/logout)
- Upload, list, download, and preview your own files
- File type and size validation (JPG, PNG, GIF, SVG, TXT, MD, CSV, max 2MB)
- Secure file access (users can only access their own files)
- Image and text file previews (modal, inline, and escapable)
- Robust error handling and logging
- Modern, user-friendly UI

---

## 🛠️ Tech Stack

- **Backend:** Ruby 3.3.4, Rails 8, PostgreSQL, RSpec, rack-cors
- **Frontend:** React 19, TypeScript, Vite, React Dropzone, React Router

---

## ⚡ Quick Start

### 1. Backend (Rails API)

#### Prerequisites

- Ruby 3.3.4
- PostgreSQL
- Bundler (`gem install bundler`)

#### Setup

```sh
cd backend
bundle install
cp config/database.yml.example config/database.yml  # Edit as needed
bundle exec rails db:create db:migrate
bundle exec rails db:seed # (optional, if you have seeds)
```

#### Run the server

```sh
bundle exec rails server
# By default runs on http://localhost:3000
```

#### CORS

- Configured to allow requests from `http://localhost:5173` (the frontend).
- Credentials (cookies) are supported.

---

### 2. Frontend (React)

#### Prerequisites

- Node.js (18+ recommended)
- npm or yarn

#### Setup

```sh
cd frontend
npm install
```

#### Run the frontend

```sh
npm run dev
# Opens at http://localhost:5173
```

---

## 🧪 Testing

- **Backend:**  
  Run RSpec tests:
  ```sh
  cd backend
  bundle exec rspec
  ```
- **Frontend:**  
  (Add your preferred frontend test runner if available.)

---

## 🖼️ File Preview

- Click the **Preview** button on any file card to see an image or text preview in a modal.
- Close the modal by clicking outside, pressing Escape, or clicking the × button.

---

## 🛡️ Security & Validation

- Only authenticated users can access file endpoints.
- Users can only access their own files.
- Only safe file types and sizes are accepted.
- All actions are logged on the backend.

---

## 📝 Notes for Reviewers

- **Credentials:** Sign up with any email and password.
- **Demo Users:** (If seeded) user1@example.com, user2@example.com, ... password: `password123`
- **API Docs:** See `backend/config/routes.rb` for endpoints.
- **Docker:** A production Dockerfile is provided in `backend/Dockerfile`.

---

## 🧩 Improvements & Ideas

- Add file sharing, search, or tagging
- Virus scanning for uploads
- More file preview types (PDF, CSV as table, etc.)
- Mobile/responsive UI improvements

---

## 📂 Project Structure

```
backend/   # Rails API (Ruby, PostgreSQL)
frontend/  # React + TypeScript + Vite
```

---

## ❓ Questions?

If you have any issues running or reviewing the app, please check the code comments or reach out to the team! 