import moment from 'moment-timezone';
import { Transactional } from 'typeorm-transactional-cls-hooked';
import { ConflictError } from '../common/error/ConflictError';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { ForbiddenError } from '../common/error/ForbiddenError';
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

    async getCard({ userId, cardId }) {
        const card = await this.customCardRepository.findWithListAndBoardById(cardId);

        if (card === undefined) {
            throw new EntityNotFoundError('Not found card');
        }

        const { list } = card;
        const { board } = list;

        const boardExisted = await this.customBoardRepository.existUserByBoardId({
            boardId: board.id,
            userId,
        });

        if (!boardExisted) {
            throw new ForbiddenError(`You're not invited`);
        }

        const cardWithCommentsAndMembers = await this.customCardRepository.findWithCommentsAndMembers(
            cardId,
        );

        return {
            id: card.id,
            title: card.title,
            content: card.content,
            dueDate: moment(card.dueDate).tz('Asia/Seoul').format(),
            position: card.position,
            list: {
                id: list.id,
                title: list.title,
            },
            board: {
                id: board.id,
                title: board.title,
            },
            members: cardWithCommentsAndMembers.members.map((member) => ({
                id: member.user.id,
                name: member.user.name,
                profileImageUrl: member.user.profileImageUrl,
            })),
            comments: cardWithCommentsAndMembers.comments.map((comment) => ({
                id: comment.id,
                content: comment.content,
                createdAt: moment(comment.createdAt).tz('Asia/Seoul').format(),
                user: {
                    id: comment.user.id,
                    name: comment.user.name,
                    profileImageUrl: comment.user.profileImageUrl,
                },
            })),
        };
    }

    @Transactional()
    async createCard({ userId, listId, title, dueDate, content }) {
        const list = await this.listRepository
            .createQueryBuilder('list')
            .select(['list.id', 'list.board'])
            .where('list.id = :listId', { listId })
            .getRawOne();
        if (!list) throw new EntityNotFoundError();
        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, list.board_id);

        const cardWithMaxPosition = await this.cardRepository
            .createQueryBuilder('card')
            .select('MAX(card.position)', 'maxPosition')
            .where('card.list = :listId', { listId })
            .getRawOne();

        const card = this.cardRepository.create({
            title,
            content,
            position: cardWithMaxPosition.maxPosition + 1,
            dueDate,
            list: list.list_id,
            creator: userId,
        });
        await this.cardRepository.save(card);
        return {
            id: card.id,
            title: card.title,
            position: card.position,
            dueDate: card.dueDate,
            content: card.content,
        };
    }

    @Transactional()
    async deleteCard({ userId, cardId }) {
        const card = await this.cardRepository
            .createQueryBuilder('card')
            .select('card.list')
            .innerJoinAndSelect('card.list', 'list')
            .where('card.id = :cardId', { cardId })
            .getRawOne();
        if (!card) throw new EntityNotFoundError();

        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, card.list_board_id);
        await this.cardRepository.delete(cardId);
    }

    async addMemberToCardByUserIds({ cardId, userId, userIds }) {
        const card = await this.cardRepository.findOne(cardId);

        if (!card) throw new EntityNotFoundError('card is not exist');

        const { id: boardId } = await this.customBoardRepository.findBoardByCardId(cardId);
        const isExistUser = await this.customBoardRepository.existUserByBoardId({
            boardId,
            userId,
        });

        if (!isExistUser) throw new ForbiddenError('no access to this card');

        if (userIds.length === 0) {
            await this.memberRepository.delete({ card: cardId });
            return;
        }

        const isExistUsers = await this.customBoardRepository.existUsersByBoardId({
            boardId,
            userIds,
        });

        if (!isExistUsers) throw new ConflictError('no members added to this card');

        await this.memberRepository.delete({ card: cardId });

        const memberData = userIds.map((item) => ({ card: cardId, user: item }));
        await this.memberRepository.save(memberData);
    }
}
