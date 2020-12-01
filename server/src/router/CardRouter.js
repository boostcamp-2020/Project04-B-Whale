import { Router } from 'express';
import { CardService } from '../service/CardService';
import { queryParser } from '../common/util/queryParser';

export const CardRouter = () => {
    const router = Router();

    router.get('/count', async (req, res) => {
        const cardService = CardService.getInstance();
        // TODO : validation 체크 로직 추가 할 것

        const { q } = req.query;
        const { id: userId } = req.user;
        const { startdate: startDate, enddate: endDate, member } = queryParser(q);

        const config = { startDate, endDate, userId, member };

        const cardCounts = await cardService.getCardCountByPeriod(config);
        res.status(200).json({ cardCounts });
    });

    return router;
};
