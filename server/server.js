require("dotenv").config();

const express = require("express");
const cors = require("cors");
const pool = require("./src/config/database");
const voterRoutes = require("./src/routes/voterRoutes");

const app = express();
const PORT = 5000;

// Middleware
app.use(cors());
app.use(express.json());

app.use("/api/voters", voterRoutes);

// Test route
app.get("/", (req, res) => {
    res.json({
        message: "Secure E-Voting System API is running"
    });
});

pool.query("SELECT NOW()", (error, result) => {
    if (error) {
        console.error("Database connection failed:", error.message);
    } else {
        console.log("Database connected successfully!");
        console.log("Database time:", result.rows[0].now);
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});