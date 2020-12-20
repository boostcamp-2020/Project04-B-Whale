import { Strategy } from 'passport-jwt';
import { getRepository } from 'typeorm';
import { User } from '../../../model/User';
import { BadRequestError } from '../../error/BadRequestError';
import { EntityNotFoundError } from '../../error/EntityNotFoundError';

export class JwtStrategy extends Strategy {
    constructor() {
        super(
            {
                secretOrKey: process.env.JWT_SECRET,
                jwtFromRequest: (req) => {
                    if (req?.headers?.authorization === undefined) {
                        throw new BadRequestError('No authorization in header');
                    }

                    const { authorization } = req.headers;
                    const splittedAuthorization = authorization?.split(' ');

                    if (
                        splittedAuthorization === undefined ||
                        splittedAuthorization?.length !== 2 ||
                        splittedAuthorization?.[0] !== 'Bearer'
                    ) {
                        throw new BadRequestError('Wrong type of JWT');
                    }

                    return splittedAuthorization[1];
                },
            },
            async (payload, done) => {
                try {
                    if (payload?.userId === undefined || typeof payload?.userId !== 'number') {
                        throw new BadRequestError('Wrong userId in JWT');
                    }

                    const userRepository = getRepository(User);
                    const user = await userRepository.findOne(payload?.userId);

                    if (user === undefined) {
                        throw new EntityNotFoundError(
                            `No user that has the userId ${payload?.userId}`,
                        );
                    }

                    return done(null, user);
                } catch (error) {
                    return done(error, null);
                }
            },
        );
    }
}
