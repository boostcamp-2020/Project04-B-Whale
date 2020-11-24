import { sign, verify } from 'jsonwebtoken';

export class JwtAsyncWrapper {
    static signAsync(payload, secretOrPrivateKey, options) {
        return new Promise((resolve, reject) => {
            sign(payload, secretOrPrivateKey, options, (err, encoded) => {
                if (err) {
                    reject(err);
                }
                resolve(encoded);
            });
        });
    }

    static verifyAsync(token, secretOrPublicKey, options) {
        return new Promise((resolve, reject) => {
            verify(token, secretOrPublicKey, options, (err, decoded) => {
                if (err) {
                    reject(err);
                }
                resolve(decoded);
            });
        });
    }
}
