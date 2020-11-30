import { Transactional } from 'typeorm-transactional-cls-hooked';
import { BaseService } from './BaseService';

export class CardService extends BaseService {
    static instance = null;

    static getInstance() {
        if (CardService.instance === null) {
            CardService.instance = new CardService();
        }

        return CardService.instance;
    }

    @Transactional()
    async getCardCountByPeriod({ startDate, endDate, userId }) {
        let query = this.cardRepository
            .createQueryBuilder('card')
            .select(`date_format(card.due_date, '%Y-%m-%d')`, 'dueDate')
            .addSelect('count(1)', 'cardCount')
            .where(`card.due_date BETWEEN '${startDate}' AND '${endDate}'`)
            .groupBy(`date_format(card.due_date, '%Y-%m-%d')`);

        if (userId) {
            query = query.innerJoin('card.members', 'member', 'member.user_id=:userId', { userId });
        }

        const cardCountList = await query.getRawMany();
        return cardCountList;
    }
}
