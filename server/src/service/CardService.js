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

        if (boardIds.length === 0) return [];

        const config = { startDate, endDate, boardIds };

        if (member === 'me') {
            config.userId = userId;
        }

        const cardCounts = await this.getCardCounts(config);
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
