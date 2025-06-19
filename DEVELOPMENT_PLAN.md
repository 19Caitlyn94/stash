# Stash Development Plan

## 🏗️ **Architecture Overview**
- **Backend**: Ruby on Rails API (JSON-only, no views)
- **Frontend**: React + TypeScript SPA
- **Database**: PostgreSQL (for production scalability)
- **Authentication**: JWT tokens with secure cookies
- **File Storage**: Local filesystem (with cloud migration path)

## 📋 **Phase 1: Core Foundation (MVP)**

### Backend Setup (Rails API)
1. **Project Initialization**
   ```bash
   rails new stash --api --database=postgresql
   ```

2. **Essential Gems**
   - `jwt` for token generation
   - `bcrypt` for password hashing (built into Rails)
   - `rack-cors` for frontend communication
   - `image_processing` for file validation
   - `rspec-rails` for testing

3. **Database Models**
   ```ruby
   # User model (Rails built-in authentication)
   # - email, password_digest, created_at, updated_at
   # File model: belongs_to :user
   #   - filename, content_type, file_size, file_path, created_at
   ```

4. **API Endpoints**
   - `POST /api/auth/login` - Authentication
   - `POST /api/upload` - File upload
   - `GET /api/files` - List user files
   - `GET /api/files/:id` - Download file
   - `GET /api/files/:id/preview` - File preview (bonus)

### Frontend Setup (React + TypeScript)
1. **Project Initialization**
   ```bash
   npm create vite@latest frontend -- --template react-ts
   ```

2. **Key Dependencies**
   - Native `fetch()` API for HTTP requests
   - `react-router-dom` for routing
   - `react-dropzone` for file uploads
   - `tailwindcss` for styling
   - `@types/*` packages for TypeScript

3. **Component Structure**
   ```
   src/
   ├── components/
   │   ├── ui/          # Reusable UI components
   │   ├── auth/
   │   ├── upload/
   │   ├── file-list/
   │   └── layout/
   ├── pages/           # Route-level components
   ├── hooks/
   ├── services/
   ├── types/
   ├── utils/
   └── stores/          # State management
   ```

## 📋 **Phase 2: Core Features Implementation**

### Backend Tasks
- [ ] **Authentication System**
  - User registration/login
  - JWT token generation/validation
  - Protected route middleware

- [ ] **File Upload Logic**
  - File type validation (whitelist approach)
  - File size validation (2MB limit)
  - Secure file storage with unique names
  - Database record creation

- [ ] **File Management**
  - List files with metadata
  - Secure file serving
  - Ownership verification
  - Error handling & logging

### Frontend Tasks
- [ ] **Authentication UI**
  - Login/register forms
  - Token storage (secure cookies)
  - Route protection
  - Auth state management

- [ ] **File Upload Interface**
  - Drag & drop upload
  - File validation feedback
  - Upload progress indication
  - Success/error messaging

- [ ] **File Management UI**
  - File list with sorting/filtering
  - File preview for images/text
  - Download functionality
  - Empty states & loading states

## 📋 **Phase 3: Polish & Security**

### Security Enhancements
- [ ] **File Security**
  - Secure filename handling
  - MIME type verification
  - File content scanning
  - Rate limiting on uploads

- [ ] **API Security**
  - Input validation & sanitization
  - CORS configuration
  - Request size limits
  - Error message sanitization

### UX/UI Polish
- [ ] **Responsive Design**
  - Mobile-first approach
  - Touch-friendly interactions
  - Progressive web app features

- [ ] **User Experience**
  - Smooth transitions
  - Optimistic updates
  - Offline detection
  - Keyboard navigation

## 🌟 **Phase 4: Creative Enhancements**

### Potential Innovation Areas
1. **Smart Organization**
   - Auto-tagging based on content
   - Smart folders/collections
   - Search functionality
   - File relationships

2. **Collaboration Features**
   - Temporary sharing links
   - File comments/annotations
   - Team workspaces
   - Real-time collaboration

3. **Advanced File Handling**
   - File versioning
   - Automatic backups
   - File compression
   - Format conversion

4. **AI Integration**
   - Content extraction from images (OCR)
   - Automatic file descriptions
   - Smart recommendations
   - Content-based search

5. **Developer Experience**
   - API documentation (Swagger)
   - SDK/CLI tools
   - Webhook notifications
   - Third-party integrations

## 🛠️ **Development Workflow**

### Day 1 Morning (3-4 hours)
- Set up Rails API with basic auth
- Set up React frontend
- Implement basic file upload
- Connect frontend to backend

### Day 1 Afternoon (3-4 hours)
- Complete file listing and download
- Add proper validation and security
- Polish UI and error handling
- Begin creative enhancements

### Testing Strategy
- Backend: RSpec with request specs
- Frontend: Jest + React Testing Library
- Integration: Cypress E2E tests
- Manual testing checklist

### Deployment Considerations
- Backend: Heroku/Railway with PostgreSQL
- Frontend: Vercel/Netlify
- File storage: AWS S3 (production)
- Environment variables for configs

## 🎯 **Success Metrics**
- All base requirements functional
- Clean, intuitive user interface
- Secure file handling
- Creative feature that adds real value
- Well-documented, maintainable code 