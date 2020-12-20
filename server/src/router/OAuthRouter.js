import { Router } from 'express';
import passport from 'passport';
import { JwtUtil } from '../common/util/JwtUtil';

export const OAuthRouter = () => {
    const router = Router();

    router.get('/login/naver', passport.authenticate('naver', null));

    router.get(
        '/callback/naver',
        passport.authenticate('naver', {
            session: false,
            failureRedirect: process.env.OAUTH_FAILURE_REDIRECT_URL,
        }),
        async (req, res) => {
            const jwtUtil = JwtUtil.getInstance();
            const token = await jwtUtil.generateAccessToken({
                userId: req?.user?.id,
                userName: req?.user?.name,
            });

            if (req.headers['user-agent'].includes('iPhone')) {
                res.redirect(`${process.env.OAUTH_IOS_FINAL_REDIRECT_URL}?token=${token}`);
            } else {
                res.redirect(`${process.env.OAUTH_WEB_FINAL_REDIRECT_URL}?token=${token}`);
            }
        },
    );

    router.get('/login/github', passport.authenticate('github', null));

    router.get(
        '/callback/github',
        passport.authenticate('github', {
            session: false,
            failureRedirect: process.env.OAUTH_FAILURE_REDIRECT_URL,
        }),
        async (req, res) => {
            const jwtUtil = JwtUtil.getInstance();
            const token = await jwtUtil.generateAccessToken({
                userId: req?.user?.id,
                userName: req?.user?.name,
            });

            if (req.headers['user-agent'].includes('iPhone')) {
                res.redirect(`${process.env.OAUTH_IOS_FINAL_REDIRECT_URL}?token=${token}`);
            } else {
                res.redirect(`${process.env.OAUTH_WEB_FINAL_REDIRECT_URL}?token=${token}`);
            }
        },
    );

    return router;
};
