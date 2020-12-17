import { Router } from 'express';
import passport from 'passport';
import { OAuthRouter } from './OAuthRouter';
import { UserRouter } from './UserRouter';
import { BoardRouter } from './BoardRouter';
import { CardRouter } from './CardRouter';
import { ListRouter } from './ListRouter';
import { CommentRouter } from './CommentRouter';
import { ActivityRouter } from './ActivityRouter';

export const IndexRouter = () => {
    const router = Router();

    router.use('/api/oauth', OAuthRouter());
    router.use('/api/user', passport.authenticate('jwt', { session: false }), UserRouter());
    router.use('/api/board', passport.authenticate('jwt', { session: false }), BoardRouter());
    router.use('/api/card', passport.authenticate('jwt', { session: false }), CardRouter());
    router.use('/api/list', passport.authenticate('jwt', { session: false }), ListRouter());
    router.use('/api/comment', passport.authenticate('jwt', { session: false }), CommentRouter());
    router.use('/api/activity', passport.authenticate('jwt', { session: false }), ActivityRouter());

    return router;
};
