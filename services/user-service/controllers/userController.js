import User from '../models/userModel.js';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { generateToken } from '../utils/generateToken.js';

// @desc     Auth user & get token
// @method   POST
// @endpoint /api/v1/users/login
// @access   Public
export const loginUser = async (req, res, next) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      res.statusCode = 404;
      throw new Error('Invalid email address. Please check your email and try again.');
    }

    const match = await bcrypt.compare(password, user.password);

    if (!match) {
      res.statusCode = 401;
      throw new Error('Invalid password. Please check your password and try again.');
    }

    generateToken(req, res, user._id);

    res.status(200).json({
      message: 'Login successful.',
      userId: user._id,
      name: user.name,
      email: user.email,
      isAdmin: user.isAdmin
    });
  } catch (error) {
    next(error);
  }
};

// @desc     Register user
// @method   POST
// @endpoint /api/v1/users
// @access   Public
export const registerUser = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;

    const userExists = await User.findOne({ email });

    if (userExists) {
      res.statusCode = 409;
      throw new Error('User already exists. Please choose a different email.');
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({
      name,
      email,
      password: hashedPassword
    });

    await user.save();

    generateToken(req, res, user._id);

    res.status(201).json({
      message: 'Registration successful. Welcome!',
      userId: user._id,
      name: user.name,
      email: user.email,
      isAdmin: user.isAdmin
    });
  } catch (error) {
    next(error);
  }
};

// @desc     Logout user / clear cookie
// @method   POST
// @endpoint /api/v1/users/logout
// @access   Private
export const logoutUser = (req, res) => {
  res.clearCookie('jwt', { httpOnly: true });
  res.status(200).json({ message: 'Logout successful' });
};

// @desc     Get user profile
// @method   GET
// @endpoint /api/v1/users/profile
// @access   Private
export const getUserProfile = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id);

    if (!user) {
      res.statusCode = 404;
      throw new Error('User not found!');
    }

    res.status(200).json({
      message: 'User profile retrieved successfully',
      userId: user._id,
      name: user.name,
      email: user.email,
      isAdmin: user.isAdmin
    });
  } catch (error) {
    next(error);
  }
};

// @desc     Get all users
// @method   GET
// @endpoint /api/v1/users
// @access   Private/Admin
export const getUsers = async (req, res, next) => {
  try {
    const users = await User.find({ isAdmin: false });

    if (!users || users.length === 0) {
      res.statusCode = 404;
      throw new Error('No users found!');
    }
    res.status(200).json(users);
  } catch (error) {
    next(error);
  }
};

// @desc     Get user by ID
// @method   GET
// @endpoint /api/v1/users/:id
// @access   Private/Admin
export const getUserById = async (req, res, next) => {
  try {
    const { id: userId } = req.params;
    const user = await User.findById(userId);
    if (!user) {
      res.statusCode = 404;
      throw new Error('User not found!');
    }
    res.status(200).json(user);
  } catch (error) {
    next(error);
  }
};

// @desc     Update user
// @method   PUT
// @endpoint /api/v1/users/:id
// @access   Private/Admin
export const updateUser = async (req, res, next) => {
  try {
    const { name, email, isAdmin } = req.body;
    const { id: userId } = req.params;
    const user = await User.findById(userId);
    if (!user) {
      res.statusCode = 404;
      throw new Error('User not found!');
    }
    user.name = name || user.name;
    user.email = email || user.email;
    user.isAdmin = Boolean(isAdmin);

    const updatedUser = await user.save();

    res.status(200).json({ message: 'User updated', updatedUser });
  } catch (error) {
    next(error);
  }
};

// @desc     Update user profile
// @method   PUT
// @endpoint /api/v1/users/profile
// @access   Private
export const updateUserProfile = async (req, res, next) => {
  try {
    const { name, email, password } = req.body;

    const user = await User.findById(req.user._id);

    if (!user) {
      res.statusCode = 404;
      throw new Error('User not found. Unable to update profile.');
    }

    user.name = name || user.name;
    user.email = email || user.email;

    if (password) {
      const hashedPassword = await bcrypt.hash(password, 10);
      user.password = hashedPassword;
    }

    const updatedUser = await user.save();

    res.status(200).json({
      message: 'User profile updated successfully.',
      userId: updatedUser._id,
      name: updatedUser.name,
      email: updatedUser.email,
      isAdmin: updatedUser.isAdmin
    });
  } catch (error) {
    next(error);
  }
};

// @desc     Delete user
// @method   DELETE
// @endpoint /api/v1/users/:id
// @access   Private/Admin
export const deleteUser = async (req, res, next) => {
  try {
    const { id: userId } = req.params;
    const user = await User.findById(userId);
    if (!user) {
      res.statusCode = 404;
      throw new Error('User not found!');
    }
    await User.deleteOne({ _id: user._id });
    res.status(200).json({ message: 'User deleted' });
  } catch (error) {
    next(error);
  }
};

// @desc     Get admins
// @method   GET
// @endpoint /api/v1/users/admins
// @access   Private/Admin
export const getAdmins = async (req, res, next) => {
  try {
    const admins = await User.find({ isAdmin: true });

    if (!admins || admins.length === 0) {
      res.statusCode = 404;
      throw new Error('No admins found!');
    }
    res.status(200).json(admins);
  } catch (error) {
    next(error);
  }
};

// @desc     Request password reset (sends reset token)
// @method   POST
// @endpoint /api/v1/users/reset-password/request
// @access   Public
export const requestPasswordReset = async (req, res, next) => {
  try {
    const { email } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      res.statusCode = 404;
      throw new Error('No account found with this email address.');
    }

    // Generate a simple reset token (in production, use crypto for secure token)
    const resetToken = jwt.sign(
      { userId: user._id, email: user.email },
      process.env.JWT_SECRET || 'your-secret-key',
      { expiresIn: '1h' }
    );

    // Create reset link
    const resetLink = `http://localhost:3000/reset-password?token=${resetToken}`;

    // Send email via Notification Service
    try {
      const emailResponse = await fetch('http://localhost:5005/api/v1/notifications/email', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({
          to: user.email,
          subject: 'Password Reset Request - AutoMERNate',
          text: `Hello ${user.name},\n\nYou requested a password reset. Click the link below to reset your password:\n\n${resetLink}\n\nThis link will expire in 1 hour.\n\nIf you didn't request this, please ignore this email.\n\nBest regards,\nAutoMERNate Team`,
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #333;">Password Reset Request</h2>
              <p>Hello <strong>${user.name}</strong>,</p>
              <p>You requested a password reset for your AutoMERNate account.</p>
              <p>Click the button below to reset your password:</p>
              <div style="text-align: center; margin: 30px 0;">
                <a href="${resetLink}" style="background-color: #ffc107; color: #000; padding: 12px 30px; text-decoration: none; border-radius: 5px; display: inline-block; font-weight: bold;">Reset Password</a>
              </div>
              <p>Or copy and paste this link in your browser:</p>
              <p style="background-color: #f5f5f5; padding: 10px; border-radius: 5px; word-break: break-all;">${resetLink}</p>
              <p style="color: #666; font-size: 14px;">This link will expire in 1 hour.</p>
              <p style="color: #666; font-size: 14px;">If you didn't request this, please ignore this email.</p>
              <hr style="border: none; border-top: 1px solid #ddd; margin: 30px 0;">
              <p style="color: #999; font-size: 12px;">Best regards,<br>AutoMERNate Team</p>
            </div>
          `
        })
      });

      if (!emailResponse.ok) {
        console.error('Failed to send email via Notification Service');
      } else {
        console.log('✅ Password reset email sent to:', user.email);
      }
    } catch (emailError) {
      console.error('Error sending email:', emailError);
      // Continue anyway - don't fail the request if email fails
    }

    res.status(200).json({
      message: 'Password reset instructions sent to your email.',
      resetToken: resetToken, // Remove this in production
      userId: user._id,
      email: user.email
    });
  } catch (error) {
    next(error);
  }
};

// @desc     Reset password with token
// @method   POST
// @endpoint /api/v1/users/reset-password/reset
// @access   Public
export const resetPassword = async (req, res, next) => {
  try {
    const { token, newPassword } = req.body;

    if (!token || !newPassword) {
      res.statusCode = 400;
      throw new Error('Reset token and new password are required.');
    }

    // Verify token
    let decoded;
    try {
      decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
    } catch (err) {
      res.statusCode = 400;
      throw new Error('Invalid or expired reset token.');
    }

    // Find user
    const user = await User.findById(decoded.userId);

    if (!user) {
      res.statusCode = 404;
      throw new Error('User not found.');
    }

    // Hash new password
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(newPassword, salt);

    await user.save();

    res.status(200).json({
      message: 'Password reset successful. You can now login with your new password.',
      userId: user._id
    });
  } catch (error) {
    next(error);
  }
};
