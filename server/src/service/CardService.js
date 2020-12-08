import moment from 'moment-timezone';
import { Transactional } from 'typeorm-transactional-cls-hooked';
import { ConflictError } from '../common/error/ConflictError';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { ForbiddenError } from '../common/error/ForbiddenError';
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
    async getMyCardCountByPeriod({ startDate, endDate, userId }) {
        const cardCounts = await this.customCardRepository.findMyCardsCountsByUserId({
            startDate,
            endDate,
            userId,
        });

        return cardCounts;
    }

    @Transactional()
    async getAllCardCountByPeriod({ startDate, endDate, userId }) {
        const boardIds = await this.customBoardRepository.findBoardIdsByUserId(userId);

        if (boardIds.length === 0) return [];

        const cardCounts = await this.customCardRepository.findAllCardCountsByBoardIds({
            startDate,
            endDate,
            boardIds,
        });
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

    @Transactional()
    async modifyCardById({ userId, cardId, listId, title, content, position, dueDate }) {
        const card = await this.cardRepository.findOne(cardId);

        if (!card) throw new EntityNotFoundError('card is not exist');

        const { id: boardId } = await this.customBoardRepository.findBoardByCardId(cardId);
        const isExistUser = await this.customBoardRepository.existUserByBoardId({
            boardId,
            userId,
        });

        if (!isExistUser) throw new ForbiddenError('no access to this card');

        if (listId && !(await this.customBoardRepository.existListByBoardId({ boardId, listId }))) {
            throw new ConflictError(`can't move this card to list`);
        }

        card.list = listId;
        card.title = title;
        card.content = content;
        card.position = position;
        card.dueDate = dueDate;

        await this.cardRepository.save(card);
    }
}
