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

        const { myBoards, invitedBoards } = await boardService.getBoardsByUserId(userId);
        let boardIds = myBoards.map((ele) => ele.id);
        boardIds = [...boardIds, ...invitedBoards.map((ele) => ele.id)];

        const config = { startDate, endDate, boardIds };
        if (member === 'me') {
            config.userId = userId;
        }

        const cardCounts = await cardService.getCardCountByPeriod(config);
        res.status(200).json({ cardCounts });
    });

    return router;
};
