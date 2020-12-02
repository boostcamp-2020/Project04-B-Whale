import { Transactional } from 'typeorm-transactional-cls-hooked';
import { BaseService } from './BaseService';
import { BoardService } from './BoardService';

export class CardService extends BaseService {
    static instance = null;

    static getInstance() {
        if (CardService.instance === null) {
            CardService.instance = new CardService();
        }

        return CardService.instance;
    }

    async getCardCounts({ startDate, endDate, boardIds, userId }) {
        let query = this.cardRepository
            .createQueryBuilder('card')
            .select(`date_format(card.due_date, '%Y-%m-%d')`, 'dueDate')
            .addSelect('count(1)', 'count')
            .innerJoin('card.list', 'list', 'list.board_id IN(:...boardIds)', { boardIds })
            .where(`card.due_date BETWEEN :startDate AND :endDate`, { startDate, endDate })
            .groupBy(`date_format(card.due_date, '%Y-%m-%d')`);

        if (userId) {
            query = query.innerJoin('card.members', 'member', 'member.user_id=:userId', { userId });
        }

        const cardCountList = await query.getRawMany();
        return cardCountList;
    }

    @Transactional()
    async getCardCountByPeriod({ startDate, endDate, userId, member }) {
        const boardService = BoardService.getInstance();

        const boardIds = await boardService.getBoardIdsByUserId(userId);
        const config = { startDate, endDate, boardIds };

        if (member === 'me') {
            config.userId = userId;
        }

        const cardCounts = await this.getCardCounts(config);
        return cardCounts;
    }
}
