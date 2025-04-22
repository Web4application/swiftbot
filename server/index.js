require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { MongoClient } = require('mongodb');

const app = express();
app.use(cors());

const username = encodeURIComponent(process.env.MONGO_USERNAME);
const password = encodeURIComponent(process.env.MONGO_PASSWORD);
const cluster = process.env.MONGO_CLUSTER;
const uri = `mongodb+srv://${username}:${password}@${cluster}/?authSource=${process.env.MONGO_AUTHSOURCE}&authMechanism=${process.env.MONGO_AUTHMECH}`;

const client = new MongoClient(uri);

app.get('/api/data', async (req, res) => {
  try {
    await client.connect();
    const db = client.db(process.env.MONGO_DB);
    const collection = db.collection(process.env.MONGO_COLLECTION);
    const results = await collection.find().toArray();
    res.json(results);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Something went wrong' });
  } finally {
    await client.close();
  }
});

app.listen(process.env.PORT, () => {
  console.log(`API server running at http://localhost:${process.env.PORT}`);
});
