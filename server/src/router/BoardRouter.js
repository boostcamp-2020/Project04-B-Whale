import { Router } from 'express';
import { BoardService } from '../service/BoardService';

export const BoardRouter = () => {
    const router = Router();

    router.get('/', async (req, res) => {
        const boardService = BoardService.getInstance();
        // TODO: jwt 추가 후, req.user에서 userId를 가져와야할 것
        const userId = 1;
        const data = await boardService.getBoardsByUserId(userId);
        res.status(200).json({ data });
    });

    return router;
};
