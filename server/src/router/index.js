import { Router } from 'express';
import passport from 'passport';
import { OAuthRouter } from './OAuthRouter';
import { UserRouter } from './UserRouter';

export const IndexRouter = () => {
    const router = Router();

    router.use('/api/oauth', OAuthRouter());
    router.use('/api/user', passport.authenticate('jwt', { session: false }), UserRouter());

    return router;
};
