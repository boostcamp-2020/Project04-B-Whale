import { Router } from 'express';
import { CardService } from '../service/CardService';
import { queryParser } from '../common/util/queryParser';
import { BoardService } from '../service/BoardService';

export const CardRouter = () => {
    const router = Router();

    router.get('/count', async (req, res) => {
        const boardService = BoardService.getInstance();
        const cardService = CardService.getInstance();

        const { q } = req.query;
        const { id: userId } = req.user;
        const { startdate: startDate, enddate: endDate, member } = queryParser(q);

        const boardIds = await boardService.getBoardIdsByUserId(userId);

        const config = { startDate, endDate, boardIds };
        if (member === 'me') {
            config.userId = userId;
        }

        const cardCounts = await cardService.getCardCountByPeriod(config);
        res.status(200).json({ cardCounts });
    });

    return router;
};
