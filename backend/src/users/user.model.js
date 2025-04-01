import { Schema, model } from 'mongoose';
import { hash } from 'bcrypt';

const userSchema =  new Schema({
    username: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
    role: {
        type: String,
        enum: ['user', 'admin'],
        required: true
    }
})

userSchema.pre('save', async function( next) {
    if(!this.isModified('password')) return next();
    this.password = await hash(this.password, 10);
    next();
}
)

const User =  model('User', userSchema);

export default User;