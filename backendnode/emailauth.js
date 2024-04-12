// Import necessary modules
const express = require('express');
const bodyParser = require('body-parser');
const { v4: uuidv4 } = require('uuid'); // Import UUID module
const app = express();

// Parse incoming requests with JSON payloads
app.use(bodyParser.json());

// Dummy database to store user information
let users = [
  {
    uid: '1',
    name: 'Alice',
    email: 'alice@example.com',
    password: 'password123'
  },
];


// Endpoint for user registration
app.post('/register', (req, res) => {
  const { name, email, password } = req.body;

  // Check if user already exists
  const existingUser = users.find(user => user.email === email);
  if (existingUser) {
    return res.status(400).json({ message: 'User already exists' });
  }

  // Create new user object with a unique ID and add to database
  const uid = uuidv4(); // Generate a unique ID
  const newUser = { uid, name, email, password };
  users.push(newUser);
  res.status(201).json({ message: 'User registered successfully', user: newUser });
});

// Endpoint for user login
app.post('/login', (req, res) => {
  const { email, password } = req.body;

  // Find user in database
  const user = users.find(user => user.email === email && user.password === password);
  if (!user) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  // Generate and return a token (dummy token for demonstration purposes)
  const token = 'token';
  res.json({ token });
});

// Start the server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
