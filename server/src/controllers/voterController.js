const bcrypt = require("bcrypt");
const pool = require("../config/database");

const registerVoter = async (req, res) => {
  try {
    const { voter_id, email, password } = req.body;

    // Check required fields
    if (!voter_id || !email || !password) {
      return res.status(400).json({
        message: "Voter ID, email and password are required",
      });
    }

    // Check if voter ID already exists
    const existingVoter = await pool.query(
      "SELECT id FROM voters WHERE voter_id = $1 OR email = $2",
      [voter_id, email],
    );

    if (existingVoter.rows.length > 0) {
      return res.status(409).json({
        message: "Voter ID or email already registered",
      });
    }

    // Hash password
    const passwordHash = await bcrypt.hash(password, 10);

    // Insert voter
    const result = await pool.query(
      `INSERT INTO voters 
            (voter_id, email, password_hash)
            VALUES ($1, $2, $3)
            RETURNING id, voter_id, email, created_at`,
      [voter_id, email, passwordHash],
    );

    res.status(201).json({
      message: "Voter registered successfully",
      voter: result.rows[0],
    });
  } catch (error) {
    console.error("Registration error:", error.message);

    res.status(500).json({
      message: "Server error",
    });
  }
};

module.exports = {
  registerVoter,
};
