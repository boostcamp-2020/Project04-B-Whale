import { Router } from 'express';
import { OAuthRouter } from './OAuthRouter';
import { BoardRouter } from './BoardRouter';

export const IndexRouter = () => {
    const router = Router();

    router.use('/api/oauth', OAuthRouter());
    // TODO: jwt 권한 확인 미들웨어 추가해야할 것
    router.use('/api/board', BoardRouter());

    return router;
};
