import { Strategy } from 'passport-github';
import { getRepository } from 'typeorm';
import { User } from '../../../model/User';

export class GitHubStrategy extends Strategy {
    constructor() {
        super(
            {
                clientID: process.env.OAUTH_GITHUB_CLIENT_ID || null,
                clientSecret: process.env.OAUTH_GITHUB_CLIENT_SECRET || null,
                callbackURL: process.env.OAUTH_GITHUB_CALLBACK_URL || null,
            },
            async (accessToken, refreshToken, profile, done) => {
                try {
                    const userRepository = getRepository(User);
                    const existedUser = await userRepository.findOne({ socialId: profile?.id });
                    if (existedUser === undefined) {
                        const user = userRepository.create({
                            socialId: profile?.id,
                            name: profile?.username,
                            // eslint-disable-next-line no-underscore-dangle
                            profileImageUrl: profile?.photos[0]?.value,
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
