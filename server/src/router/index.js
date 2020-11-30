import { Router } from 'express';
import passport from 'passport';
import { OAuthRouter } from './OAuthRouter';
import { UserRouter } from './UserRouter';
import { BoardRouter } from './BoardRouter';

export const IndexRouter = () => {
    const router = Router();

    router.use('/api/oauth', OAuthRouter());
    router.use('/api/user', passport.authenticate('jwt', { session: false }), UserRouter());
    router.use('/api/board', passport.authenticate('jwt', { session: false }), BoardRouter());

    return router;
};