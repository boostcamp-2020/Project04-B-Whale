import { Router } from 'express';
import { ListService } from '../service/ListService';
import { CardService } from '../service/CardService';
import { CardDto } from '../dto/CardDto';
import { validator } from '../common/util/validator';

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

    router.post('/:id/card', async (req, res) => {
        const cardService = CardService.getInstance();
        const config = {
            userId: req.user.id,
            listId: req.params.id,
            title: req.body.title,
            dueDate: req.body.dueDate,
            content: req.body.content,
        };
        await validator(CardDto, {
            dueDate: config.dueDate,
        });

        await cardService.createCard(config);
        res.sendStatus(201);
    });

    return router;
};
