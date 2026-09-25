# 🔐 Secure E-Voting System

A simple web-based **Secure E-Voting System** developed as an MCA project. The system allows registered voters to securely log in, verify their identity using OTP, view available candidates, and cast their vote online.

The project focuses on basic security, authentication, and secure storage of votes.

## 🚀 Features

- 👤 Voter registration
- 🔑 Secure login using password authentication
- 📩 OTP verification through email
- 🪪 JWT-based authentication
- 🗳️ Candidate listing
- ✅ Online vote casting
- 🔒 Encrypted vote storage
- 👻 Anonymous vote storage — voter identity is not directly stored with the vote
- 📋 Basic audit logs
- 👨‍💼 Admin section for managing elections and candidates
- 🗄️ PostgreSQL database

## 🛠️ Technologies Used

### Frontend

- React.js
- JavaScript
- HTML
- CSS
- Axios / Fetch API

### Backend

- Node.js
- Express.js

### Database

- PostgreSQL
- Supabase

### Security

- bcrypt — password hashing
- JWT — authentication
- Nodemailer — OTP email verification
- AES encryption — securing vote data

## 📂 Project Structure

```text
secure-e-voting-system/
│
├── client/
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
│
├── server/
│   ├── src/
│   │   ├── config/
│   │   │   └── database.js
│   │   ├── controllers/
│   │   ├── routes/
│   │   └── ...
│   │
│   ├── .env
│   ├── package.json
│   └── server.js
│
├── database/
│   └── schema.sql
│
├── README.md
└── ...
```

## 🔄 Basic Working Flow

```text
Voter Registration
        ↓
Login
        ↓
OTP Verification
        ↓
Authentication
        ↓
View Candidates
        ↓
Select Candidate
        ↓
Cast Vote
        ↓
Encrypt Vote
        ↓
Store Vote
        ↓
Confirmation
```

## 🔐 Security Approach

The system includes several basic security measures:

### Password Security

Passwords are hashed using **bcrypt** before being stored in the database.

### Authentication

After successful login and OTP verification, **JWT** is used to authenticate the voter for protected operations.

### OTP Verification

An OTP is sent to the registered email address using **Nodemailer** before the voter can access the voting process.

### Vote Encryption

Votes are encrypted before being stored in the database using AES-based encryption.

### Anonymous Voting

The `votes` table does not directly store the voter's ID with the vote. This helps separate the voter's identity from their selected candidate.

## 🗄️ Database

The project uses **PostgreSQL** through **Supabase**.

Main database tables include:

- `elections`
- `voters`
- `candidates`
- `votes`
- `audit_log`

The database schema is available in:

```text
database/schema.sql
```

## ⚙️ Installation & Setup

### 1. Clone the Repository

```bash
git clone <your-github-repository-url>
cd secure-e-voting-system
```

### 2. Install Backend Dependencies

```bash
cd server
npm install
```

### 3. Configure Environment Variables

Create a `.env` file inside the `server` folder.

Example:

```env
PORT=5000
DATABASE_URL=your_postgresql_connection_string
JWT_SECRET=your_jwt_secret

EMAIL_USER=your_email
EMAIL_PASSWORD=your_email_password
```

> Do not upload your `.env` file or passwords/API keys to GitHub.

### 4. Start the Backend

```bash
npm run dev
```

The server should start at:

```text
http://localhost:5000
```

### 5. Install Frontend Dependencies

Open another terminal:

```bash
cd client
npm install
```

### 6. Start the Frontend

```bash
npm run dev
```

The React application will then be available through the local URL shown by Vite.

## 🔗 API

Some of the backend API endpoints include:

### Voter Registration

```http
POST /api/voters/register
```

### Login

```http
POST /api/voters/login
```

Additional endpoints are being developed for OTP verification, candidates, voting, and administration.

## 📌 Current Project Status

**Work in Progress 🚧**

### Completed / In Progress
- [x] Project structure
- [x] React frontend setup
- [x] Node.js + Express backend setup
- [x] PostgreSQL / Supabase connection
- [x] Database schema
- [x] Voter registration API
- [ ] Login interface
- [ ] OTP verification
- [ ] Candidate listing
- [ ] Voting interface
- [ ] Vote encryption
- [ ] Admin dashboard
- [ ] Testing
- [ ] Deployment

## 🎯 Future Improvements
- Improve the admin dashboard
- Add better input validation
- Add stronger access control
- Improve UI/UX
- Add detailed audit logging
- Perform security testing
- Deploy the application online

## 👩‍💻 Project

**Secure E-Voting System**

Developed as an MCA academic project using React.js, Node.js, Express.js, and PostgreSQL.

---

⭐ This project is developed for **educational purposes** and is not intended for use in real-world elections.
