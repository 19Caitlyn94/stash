# Stash Challenge Summary

## 🎯 **Core Concept**
Build a personal file cache system where users can securely upload, store, and access their own files - think of it as a private, temporary stash for screenshots, notes, and documents.

## 📋 **Essential Requirements**

### Backend API (Ruby on Rails)
- **Authentication**: All endpoints require authentication (session/token-based)
- **File Upload** (`POST /upload`): 
  - Support: JPG, PNG, GIF, SVG, TXT, MD, CSV
  - Max size: 2MB
  - Returns unique file identifier
- **File List** (`GET /files`): Returns user's files only
- **File Download** (`GET /files/:file_id`): Raw content with strict ownership checks

### Frontend (React + TypeScript)
- **Login/Auth UI**: Simple authentication with error handling
- **Upload View**: File upload with validation feedback
- **File List View**: Display user's files (name, date, size, type)
- **Download View**: File download with optional previews

### Security & Validation
- Users can ONLY access their own files
- Reject unsupported file types and oversized files
- Proper error handling and user feedback

## 🌟 **Creative Enhancement Opportunity**
After building the base requirements, teams should innovate and add unique features that would make this a compelling product in 2025.

## 📊 **Scoring (100 points)**
- Functional completeness (10pts)
- Authentication & access control (10pts) 
- File validation & security (10pts)
- Frontend quality (10pts)
- Observability & logging (10pts)
- Technical clarity (10pts)
- **Creative enhancements (BONUS +40pts)**

## 🎨 **Philosophy**
Start with the tutorial-level base requirements, then think like a product team - what would make this genuinely useful and delightful in 2025? 