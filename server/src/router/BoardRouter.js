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
        const createdBoardId = await boardService.createBoard({
            userId: req.user.id,
            title: req.body.title,
            color: req.body.color,
        });
        res.status(201).json({ id: createdBoardId });
    });

    router.get('/:id', async (req, res) => {
        const boardService = BoardService.getInstance();
        const detailBoard = await boardService.getDetailBoard(req.params.id);
        res.status(200).json(detailBoard);
    });

    router.post('/:id/invitation', async (req, res) => {
        const boardService = BoardService.getInstance();
        await boardService.inviteUserIntoBoard(req.params.id, req.body.userId);
        res.status(201);
    });

    return router;
};
