import User from './user.model';
import { sign } from 'jsonwebtoken';
import bcrypt from 'bcryptjs';  // Import bcrypt for password comparison

const JWT_SECRET = process.env.JWT_SECRET_KEY;

// Register a new user
export const registerUser = async (req, res) => {
  const { username, password, role } = req.body;

  try {
    // Check if the user already exists
    const userExists = await User.findOne({ username });
    if (userExists) {
      return res.status(400).json({ message: 'Username already taken' });
    }

    // Create new user instance
    const newUser = new User({
      username,
      password,
      role
    });

    // Save the new user to the database
    await newUser.save();

    // Return success message
    res.status(201).json({
      message: 'User registered successfully',
    });
  } catch (error) {
    console.error('Error registering user:', error);
    res.status(500).json({ message: 'Server error' });
  }
};

// User login
export const loginUser = async (req, res) => {
  const { username, password } = req.body;

  try {
    // Find the user by username
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Compare the provided password with the stored hashed password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: 'Invalid password' });
    }

    // Generate JWT token
    const token = sign(
      { id: user._id, username: user.username, role: user.role },
      JWT_SECRET,
      { expiresIn: '1h' }
    );

    // Send success response with the JWT token
    res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        username: user.username,
        role: user.role
      }
    });
  } catch (error) {
    console.error('Error logging in user:', error);
    res.status(500).json({ message: 'Server error' });
  }
};