import { Router } from 'express';
import { OAuthRouter } from './OAuthRouter';
import { UserRouter } from './UserRouter';

export const IndexRouter = () => {
    const router = Router();

    router.use('/api/oauth', OAuthRouter());
    router.use('/api/user', UserRouter());

    return router;
};
