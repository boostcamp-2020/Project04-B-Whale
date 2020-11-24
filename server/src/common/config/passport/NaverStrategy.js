import { Strategy } from 'passport-naver';
import { getRepository } from 'typeorm';
import { User } from '../../../model/User';

export class NaverStrategy extends Strategy {
    constructor() {
        super(
            {
                clientID: process.env.OAUTH_NAVER_CLIENT_ID,
                clientSecret: process.env.OAUTH_NAVER_CLIENT_SECRET,
                callbackURL: process.env.OAUTH_NAVER_CALLBACK_URL,
            },
            async (accessToken, refreshToken, profile, done) => {
                try {
                    const userRepository = getRepository(User);
                    const existedUser = await userRepository.findOne({ socialId: profile?.id });

                    if (existedUser === undefined) {
                        const user = userRepository.create({
                            socialId: profile?.id,
                            name: profile?.displayName,
                            // eslint-disable-next-line no-underscore-dangle
                            profileImageUrl: profile?._json?.profile_image,
                        });
                        await userRepository.save(user);

                        return done(null, user);
                    }

                    return done(null, existedUser);
                } catch (error) {
                    return done(error, null);
                }
            },
        );
    }
}
