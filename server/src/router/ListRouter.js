import { Router } from 'express';
import { ListService } from '../service/ListService';

export const ListRouter = () => {
    const router = Router();

    router.patch('/:id', async (req, res) => {
        const listService = ListService.getInstance();
        await listService.updateList(req.user.id, req.params.id, req.body.position, req.body.title);
        res.sendStatus(204);
    });

    return router;
};
