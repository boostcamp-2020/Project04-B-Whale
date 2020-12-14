import { Router } from 'express';
import { isNumberString } from 'class-validator';
import { CardService } from '../service/CardService';
import { queryParser } from '../common/util/queryParser';
import { validator } from '../common/util/validator';
import { CardCountDto } from '../dto/CardCountDto';
import { GetCardsByDateQueryDto } from '../dto/GetCardsByDateQueryDto';
import { CardDto } from '../dto/CardDto';
import { BadRequestError } from '../common/error/BadRequestError';
import { AddMemberBodyDto } from '../dto/AddMemberBodyDto';
import { CommentService } from '../service/CommentService';

export const CardRouter = () => {
    const router = Router();

    router.get('/count', async (req, res) => {
        await validator(CardCountDto, req.query, ['isQuery']);

        const cardService = CardService.getInstance();
        const { q } = req.query;
        const { id: userId } = req.user;
        const { startdate: startDate, enddate: endDate, member } = queryParser(q);
        const config = { startDate, endDate, userId, member };

        await validator(CardCountDto, config, ['queryValue']);

        let cardCounts = null;

        if (member === undefined) {
            cardCounts = await cardService.getAllCardCountByPeriod(config);
        } else if (member === 'me') {
            cardCounts = await cardService.getMyCardCountByPeriod(config);
        }

        res.status(200).json({ cardCounts });
    });

    router.get('/', async (req, res) => {
        const cardService = CardService.getInstance();
        const userId = req.user.id;
        const { date, member } = queryParser(req.query?.q);
        await validator(GetCardsByDateQueryDto, { date, member }, []);

        let cards = null;

        if (member === undefined) {
            cards = await cardService.getAllCardsByDueDate({ userId, dueDate: date });
        } else if (member === 'me') {
            cards = await cardService.getMyCardsByDueDate({ userId, dueDate: date });
        }

        res.status(200).json({ cards });
    });

    router.patch('/:cardId', async (req, res) => {
        const cardService = CardService.getInstance();
        const { id: userId } = req.user;
        const { cardId } = req.params;
        const { listId, title, content, position, dueDate } = req.body;
        await validator(CardDto, { listId, title, content, position, dueDate });

        await cardService.modifyCardById({
            userId,
            cardId,
            listId,
            title,
            content,
            position,
            dueDate,
        });
        res.status(204).end();
    });

    router.get('/:cardId', async (req, res) => {
        const cardService = CardService.getInstance();
        const userId = req.user.id;
        const { cardId } = req.params;

        if (cardId === undefined || !isNumberString(cardId)) {
            throw new BadRequestError('Wrong params');
        }

        const card = await cardService.getCard({ userId, cardId });

        res.status(200).json(card);
    });

    router.delete('/:id', async (req, res) => {
        const cardService = CardService.getInstance();
        const config = {
            userId: req.user.id,
            cardId: req.params.id,
        };
        await cardService.deleteCard(config);
        res.sendStatus(204);
    });

    router.put('/:cardId/member', async (req, res) => {
        const cardService = CardService.getInstance();
        const { id: userId } = req.user;
        const { cardId } = req.params;
        const { userIds } = req.body;
        await validator(AddMemberBodyDto, { cardId, userIds });

        await cardService.addMemberToCardByUserIds({ cardId, userId, userIds });
        res.status(204).end();
    });

    router.post('/:cardId/comment', async (req, res) => {
        const commentService = CommentService.getInstance();
        const userId = req.user.id;
        const { cardId } = req.params;
        const { content } = req.body;

        if (cardId === undefined || !isNumberString(cardId)) {
            throw new BadRequestError('Wrong params');
        }

        if (content === undefined) {
            throw new BadRequestError('Empty content');
        }

        const responseBody = await commentService.addComment({ userId, cardId, content });

        res.status(201).json(responseBody);
    });

    return router;
};
