import moment from 'moment-timezone';
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

    async findMyCardsCountsByUserId({ startDate, endDate, userId }) {
        const cardCountList = this.cardRepository
            .createQueryBuilder('card')
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
        const cardCountList = this.cardRepository
            .createQueryBuilder('card')
            .select(`date_format(card.due_date, '%Y-%m-%d')`, 'dueDate')
            .addSelect('count(1)', 'count')
            .innerJoin('card.list', 'list', 'list.board_id IN(:...boardIds)', { boardIds })
            .where(`card.due_date BETWEEN :startDate AND :endDate`, { startDate, endDate })
            .groupBy(`date_format(card.due_date, '%Y-%m-%d')`)
            .getRawMany();

        return cardCountList;
    }

    @Transactional()
    async getMyCardCountByPeriod({ startDate, endDate, userId }) {
        const cardCounts = this.findMyCardsCountsByUserId({ startDate, endDate, userId });
        return cardCounts;
    }

    @Transactional()
    async getAllCardCountByPeriod({ startDate, endDate, userId }) {
        const boardService = BoardService.getInstance();

        const boardIds = await boardService.getBoardIdsByUserId(userId);

        if (boardIds.length === 0) return [];

        const cardCounts = await this.findAllCardCountsByBoardIds({ startDate, endDate, boardIds });
        return cardCounts;
    }

    @Transactional()
    async getMyCardsByDueDate({ userId, dueDate }) {
        const [myCards, assignedCards] = await Promise.all([
            await this.customCardRepository.findByDueDateAndCreatorId({
                dueDate,
                creatorId: userId,
            }),
            await this.customCardRepository.findByDueDateAndMemberUserId({ dueDate, userId }),
        ]);

        if (myCards?.length === 0 && assignedCards?.length === 0) {
            return [];
        }

        const cardMap = new Map();

        myCards.forEach((card) => {
            cardMap.set(card.id, card);
        });
        assignedCards.forEach((card) => {
            cardMap.set(card.id, card);
        });

        return Array.from(cardMap.values())
            .sort((a, b) => {
                return moment(a.dueDate).unix() - moment(b.dueDate).unix();
            })
            .map((card) => ({
                id: card.id,
                title: card.title,
                dueDate: moment(card.dueDate).tz('Asia/Seoul').format(),
                commentCount: card.commentCount,
            }));
    }

    @Transactional()
    async getAllCardsByDueDate({ userId, dueDate }) {
        const [myBoards, invitedBoards] = await Promise.all([
            this.customBoardRepository.findByCreatorId(userId),
            this.customBoardRepository.findInvitedBoardsByUserId(userId),
        ]);

        const boardIds = [
            ...myBoards.map((board) => board.id),
            ...invitedBoards.map((board) => board.id),
        ];

        if (boardIds?.length === 0) {
            return [];
        }

        const cards = await this.customCardRepository.findByDueDateAndBoardIds({
            dueDate,
            boardIds,
        });

        return cards.map((card) => ({
            id: card.id,
            title: card.title,
            dueDate: moment(card.dueDate).tz('Asia/Seoul').format(),
            commentCount: card.commentCount,
        }));
    }
}
