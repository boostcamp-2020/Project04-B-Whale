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
            .loadRelationCountAndMap('a.commentCount', 'a.comments')
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
            .loadRelationCountAndMap('a.commentCount', 'a.comments')
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
            .loadRelationCountAndMap('a.commentCount', 'a.comments')
            .where('a.dueDate >= :startDate AND a.dueDate < :endDate', { startDate, endDate })
            .orderBy('a.dueDate', 'ASC')
            .getMany();

        return cards;
    }

    async findMyCardsCountsByUserId({ startDate, endDate, userId }) {
        const cardCountList = await this.createQueryBuilder('card')
            .select(`date_format(card.due_date, '%Y-%m-%d')`, 'dueDate')
            .addSelect('count(1)', 'count')
            .leftJoin('card.members', 'member')
            .where(`card.due_date BETWEEN :startDate AND :endDate`, { startDate, endDate })
            .andWhere('card.creator_id=:userId', { userId })
            .orWhere('member.user_id=:userId', { userId })
            .groupBy(`date_format(card.due_date, '%Y-%m-%d')`)
            .getRawMany();

        return cardCountList;
    }

    async findAllCardCountsByBoardIds({ startDate, endDate, boardIds }) {
        const cardCountList = await this.createQueryBuilder('card')
            .select(`date_format(card.due_date, '%Y-%m-%d')`, 'dueDate')
            .addSelect('count(1)', 'count')
            .innerJoin('card.list', 'list', 'list.board_id IN(:...boardIds)', { boardIds })
            .where(`card.due_date BETWEEN :startDate AND :endDate`, { startDate, endDate })
            .groupBy(`date_format(card.due_date, '%Y-%m-%d')`)
            .getRawMany();

        return cardCountList;
    }
}
