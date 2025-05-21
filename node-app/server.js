const express = require("express");
const cors = require("cors");
const axios = require("axios");

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Example route: proxy request to Python backend analyze endpoint
app.post("/analyze", async (req, res) => {
  try {
    const response = await axios.post("http://python-backend:5000/analyze", req.body);
    res.json(response.data);
  } catch (error) {
    res.status(500).json({ error: "Failed to analyze script." });
  }
});

app.listen(PORT, () => {
  console.log(`Node.js server listening on port ${PORT}`);
});
