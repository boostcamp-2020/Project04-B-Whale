import { Router } from 'express';
import { BoardService } from '../service/BoardService';

export const BoardRouter = () => {
    const router = Router();

    router.get('/', async (req, res) => {
        const boardService = BoardService.getInstance();
        const { id } = req.user;
        const data = await boardService.getBoardsByUserId(id);
        res.status(200).json(data);
    });

    router.post('/', async (req, res) => {
        const boardService = BoardService.getInstance();
        const createdBoardId = await boardService.createBoard(req.user.id, req.body.title);
        res.status(201).json({ message: 'success', id: createdBoardId });
    });

    return router;
};
