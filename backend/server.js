// server.js
const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
const port = 3000; // You can change this port if necessary

// Middleware
app.use(cors());
app.use(bodyParser.json());

// MySQL database connection
const db = mysql.createConnection({
  host: 'localhost', // or your MySQL server IP
  user: 'root', // your MySQL username
  password: '', // your MySQL password
  database: 'flutter_app', // database name you created
});

db.connect((err) => {
  if (err) {
    console.error('Database connection failed:', err);
    return;
  }
  console.log('Connected to MySQL database');
});

// API endpoint for user registration
app.post('/register', (req, res) => {
  const { username, email, password } = req.body;

  // Validate input
  if (!username || !email || !password) {
    return res.status(400).json({ status: 'error', message: 'All fields are required' });
  }

  // Insert user into the database
  const query = 'INSERT INTO users (username, email, password) VALUES (?, ?, ?)';
  db.query(query, [username, email, password], (err, result) => {
    if (err) {
      console.error('Error inserting user:', err);
      return res.status(500).json({ status: 'error', message: 'Registration failed' });
    }

    res.status(201).json({ status: 'success', message: 'User registered successfully' });
  });
});


// API endpoint for user login
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  // Validate input
  if (!username || !password) {
    return res.status(400).json({ status: 'error', message: 'Username and password are required' });
  }

  // Check if the user exists and the password matches
  const query = 'SELECT * FROM users WHERE username = ? AND password = ?';
  db.query(query, [username, password], (err, results) => {
    if (err) {
      console.error('Error during login:', err);
      return res.status(500).json({ status: 'error', message: 'Login failed' });
    }

    if (results.length === 0) {
      return res.status(401).json({ status: 'error', message: 'Invalid username or password' });
    }

    res.status(200).json({ status: 'success', message: 'Login successful' });
  });
});


// Start the server
app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
