import moment from 'moment';
import { EntityRepository } from 'typeorm';
import { BaseRepository } from 'typeorm-transactional-cls-hooked';
import { Card } from '../model/Card';

@EntityRepository(Card)
export class CustomCardRepository extends BaseRepository {
    async findByDueDateAndCreatorId({ dueDate, creatorId }) {
        const startDate = moment(dueDate).format('YYYY-MM-DD');
        const endDate = moment(dueDate).add(1, 'day').format('YYYY-MM-DD');

        const cards = await this.createQueryBuilder('a')
            .where('a.dueDate >= :startDate AND a.dueDate < :endDate', { startDate, endDate })
            .andWhere('a.creator.id = :creatorId', { creatorId })
            .getMany();

        return cards;
    }

    async findByDueDateAndMemberUserId({ dueDate, userId }) {
        const startDate = moment(dueDate).format('YYYY-MM-DD');
        const endDate = moment(dueDate).add(1, 'day').format('YYYY-MM-DD');

        const cards = await this.createQueryBuilder('a')
            .innerJoin('a.members', 'b', 'b.user.id = :userId', { userId })
            .where('a.dueDate >= :startDate AND a.dueDate < :endDate', { startDate, endDate })
            .getMany();

        return cards;
    }

    async findByDueDateAndBoardIds({ dueDate, boardIds }) {
        const startDate = moment(dueDate).format('YYYY-MM-DD');
        const endDate = moment(dueDate).add(1, 'day').format('YYYY-MM-DD');

        const cards = await this.createQueryBuilder('a')
            .innerJoin('a.list', 'b', 'b.board.id IN(:...boardIds)', {
                boardIds,
            })
            .where('a.dueDate >= :startDate AND a.dueDate < :endDate', { startDate, endDate })
            .orderBy('a.dueDate', 'ASC')
            .getMany();

        return cards;
    }
}
