import { Router } from 'express';
import { ListService } from '../service/ListService';

export const ListRouter = () => {
    const router = Router();

    router.patch('/:id', async (req, res) => {
        const listService = ListService.getInstance();
        const config = {
            userId: req.user.id,
            listId: req.params.id,
            position: req.body.position,
            title: req.body.title,
        };
        await listService.updateList(config);
        res.sendStatus(204);
    });

    router.delete('/:id', async (req, res) => {
        const listService = ListService.getInstance();
        const config = {
            userId: req.user.id,
            listId: req.params.id,
        };
        await listService.deleteList(config);
        res.sendStatus(204);
    });

    return router;
};
