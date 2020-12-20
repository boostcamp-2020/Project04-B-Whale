import { JwtAsyncWrapper } from './JwtAsyncWrapper';

export class JwtUtil {
    static instance = null;

    static getInstance() {
        if (this.instance === null) {
            this.instance = new JwtUtil(process.env.JWT_SECRET);
        }

        return this.instance;
    }

    constructor(secret) {
        this.secret = secret;
    }

    async generateAccessToken(payload) {
        const accessToken = await JwtAsyncWrapper.signAsync(payload, this.secret, {
            expiresIn: '1d',
        });

        return `Bearer ${accessToken}`;
    }

    async validateAccessToken(token) {
        if (!this.matchBearer(token)) {
            throw new Error();
        }

        const payload = await JwtAsyncWrapper.verifyAsync(token.split(' ')[1], this.secret);

        return payload;
    }

    matchBearer(token) {
        return token.split(' ')[0] === 'Bearer';
    }
}
