require('dotenv').config();
const express = require("express");
const axios = require("axios");
const winston = require("winston");

const app = express();
app.use(express.json());

const PYTHON_API_KEY = process.env.PYTHON_API_KEY;
const DART_API_KEY = process.env.DART_API_KEY;
const PYTHON_BACKEND_URL = process.env.PYTHON_BACKEND_URL || "http://python-backend:5000";
const DART_BACKEND_URL = process.env.DART_BACKEND_URL || "http://dart-app:8080";

const logger = winston.createLogger({
  level: "info",
  transports: [new winston.transports.Console()],
});

// Health check
app.get("/health", (req, res) => res.send("OK"));

// Analyze using Python service
app.post("/analyze-python", async (req, res) => {
  try {
    logger.info("Python analysis request received");
    const response = await axios.post(
      `${PYTHON_BACKEND_URL}/analyze`,
      req.body,
      { headers: { "X-API-Key": PYTHON_API_KEY } }
    );
    logger.info("Python analysis successful");
    res.json(response.data);
  } catch (error) {
    logger.error("Python analysis failed:", error.message);
    res.status(500).json({ error: "Python analysis failed." });
  }
});

// Analyze using Dart service
app.post("/analyze-dart", async (req, res) => {
  try {
    logger.info("Dart analysis request received");
    const response = await axios.post(
      `${DART_BACKEND_URL}/analyze`,
      req.body,
      { headers: { "X-API-Key": DART_API_KEY } }
    );
    logger.info("Dart analysis successful");
    res.json(response.data);
  } catch (error) {
    logger.error("Dart analysis failed:", error.message);
    res.status(500).json({ error: "Dart analysis failed." });
  }
});

// Combined analyze both
app.post("/analyze-all", async (req, res) => {
  try {
    logger.info("Combined analysis started");
    const [pythonRes, dartRes] = await Promise.all([
      axios.post(`${PYTHON_BACKEND_URL}/analyze`, req.body, { headers: { "X-API-Key": PYTHON_API_KEY } }),
      axios.post(`${DART_BACKEND_URL}/analyze`, req.body, { headers: { "X-API-Key": DART_API_KEY } }),
    ]);

    const combinedResult = {
      python: pythonRes.data,
      dart: dartRes.data,
      message: "Combined analysis results",
    };

    logger.info("Combined analysis completed");
    res.json(combinedResult);
  } catch (error) {
    logger.error("Combined analysis failed:", error.message);
    res.status(500).json({ error: "Combined analysis failed." });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  logger.info(`Node.js API Gateway listening on port ${PORT}`);
});
