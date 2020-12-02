import { Router } from 'express';
import { CardService } from '../service/CardService';
import { queryParser } from '../common/util/queryParser';
import { validator } from '../common/util/validator';
import { CardCountDto } from '../dto/CardCountDto';

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

        const cardCounts = await cardService.getCardCountByPeriod(config);
        res.status(200).json({ cardCounts });
    });

    return router;
};
