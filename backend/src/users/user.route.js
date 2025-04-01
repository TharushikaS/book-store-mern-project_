import { Router } from 'express';
import { registerUser, loginUser } from './user.controller';  // Import the controller functions

const router = Router();

// Route for registering a new user
router.post('/register', registerUser);

// Route for logging in a user
router.post('/login', loginUser);

// Route for admin login (this seems specific to admin login)
router.post('/admin', async (req, res) => {
    const { username, password } = req.body;
    try {
        const admin = await User.findOne({ username });
        if (!admin) {
            return res.status(404).send({ message: "Admin not found!" });
        }

        // Compare password with hashed password in the database
        const isMatch = await bcrypt.compare(password, admin.password);
        if (!isMatch) {
            return res.status(401).send({ message: "Invalid password!" });
        }

        // Generate JWT token
        const token = sign(
            { id: admin._id, username: admin.username, role: admin.role },
            process.env.JWT_SECRET_KEY,
            { expiresIn: '1h' }
        );

        return res.status(200).json({
            message: "Authentication successful",
            token,
            user: {
                username: admin.username,
                role: admin.role
            }
        });

    } catch (error) {
        console.error("Failed to login as admin", error);
        res.status(401).send({ message: "Failed to login as admin" });
    }
});

export default router;
