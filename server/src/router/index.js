import { Router } from 'express';
import { OAuthRouter } from './OAuthRouter';

export const IndexRouter = () => {
    const router = Router();

    router.use('/api/oauth', OAuthRouter());

    return router;
};
