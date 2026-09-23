const express = require("express");
const { registerVoter } = require("../controllers/voterController");

const router = express.Router();

router.post("/register", registerVoter);

module.exports = router;
