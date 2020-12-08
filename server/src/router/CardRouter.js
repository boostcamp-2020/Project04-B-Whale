import { Router } from 'express';
import { CardService } from '../service/CardService';
import { queryParser } from '../common/util/queryParser';
import { validator } from '../common/util/validator';
import { CardCountDto } from '../dto/CardCountDto';
import { GetCardsByDateQueryDto } from '../dto/GetCardsByDateQueryDto';
import { CardDto } from '../dto/CardDto';
import { MemberDto } from '../dto/MemberDto';
import { BadRequestError } from '../common/error/BadRequestError';

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

        if (cardId === undefined) {
            throw new BadRequestError('No params');
        }

        const card = await cardService.getCard({ userId, cardId });

        res.status(200).json(card);
    });

    router.put('/:cardId/member', async (req, res) => {
        const cardService = CardService.getInstance();
        const { id: userId } = req.user;
        const { cardId } = req.params;
        const { userIds } = req.body;
        await validator(MemberDto, { user: true, userIds });

        await cardService.addMemberToCardByUserIds({ cardId, userId, userIds });
        res.status(204).end();
    });

    return router;
};
