import { Transactional } from 'typeorm-transactional-cls-hooked';
import { BaseService } from './BaseService';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { ForbiddenError } from '../common/error/ForbiddenError';

export class BoardService extends BaseService {
    static instance = null;

    static getInstance() {
        if (BoardService.instance === null) {
            BoardService.instance = new BoardService();
        }

        return BoardService.instance;
    }

    async getMyBoards(id) {
        const boards = await this.boardRepository.find({
            select: ['id', 'title'],
            where: { creator: id },
        });
        return boards;
    }

    async getInvitedBoards(id) {
        const boards = await this.boardRepository
            .createQueryBuilder('board')
            .select('board.id')
            .addSelect('board.title')
            .innerJoin('board.invitations', 'invitation', 'invitation.user_id=:userId', {
                userId: id,
            })
            .getMany();
        return boards;
    }

    @Transactional()
    async getBoardsByUserId(userId) {
        const promises = [this.getMyBoards(userId), this.getInvitedBoards(userId)];
        const [myBoards, invitedBoards] = await Promise.all(promises);

        return { myBoards, invitedBoards };
    }

    @Transactional()
    async getBoardIdsByUserId(userId) {
        const boards = await this.boardRepository
            .createQueryBuilder('board')
            .select('board.id', 'id')
            .leftJoin('board.invitations', 'invitation')
            .where(`board.creator_id=:userId or invitation.user_id=:userId`, { userId })
            .getRawMany();

        const boardIds = boards.map((ele) => ele.id);

        return boardIds;
    }

    @Transactional()
    async createBoard({ userId, title, color }) {
        const board = {
            creator: userId,
            title,
            color,
        };
        const createBoard = this.boardRepository.create(board);
        await this.boardRepository.save(createBoard);
        return createBoard.id;
    }

    @Transactional()
    async getDetailBoard(hostId, boardId) {
        const boardDetail = await this.boardRepository
            .createQueryBuilder('board')
            .innerJoin('board.creator', 'creator')
            .leftJoin('board.invitations', 'invitations')
            .leftJoin('invitations.user', 'user')
            .leftJoin('board.lists', 'lists')
            .leftJoin('lists.cards', 'cards')
            .leftJoin('cards.comments', 'comments')
            .select([
                'board',
                'creator.id',
                'creator.name',
                'creator.profileImageUrl',
                'invitations',
                'user.id',
                'user.name',
                'user.profileImageUrl',
                'lists',
                'cards.id',
                'cards.title',
                'cards.position',
                'cards.dueDate',
            ])
            .loadRelationCountAndMap('cards.commentCount', 'cards.comments')
            .where('board.id = :id', { id: boardId })
            .getOne();
        if (!boardDetail) {
            throw new EntityNotFoundError();
        }
        const invitationOfHost = await this.invitationRepository.find({
            select: ['id'],
            where: { user: hostId, board: boardId },
        });
        const boardOfCreator = await this.boardRepository.find({
            select: ['id'],
            where: { id: boardId, creator: hostId },
        });
        if (!invitationOfHost.length && !boardOfCreator.length) {
            throw new ForbiddenError();
        }
        if (Array.isArray(boardDetail?.invitations)) {
            boardDetail.invitedUsers = boardDetail.invitations.map((v) => v.user);
            delete boardDetail.invitations;
        }
        return boardDetail;
    }

    @Transactional()
    async inviteUserIntoBoard(hostId, boardId, userId) {
        const invitationOfHost = await this.invitationRepository.find({
            select: ['id'],
            where: { user: hostId, board: boardId },
        });
        const boardOfCreator = await this.boardRepository.find({
            select: ['id'],
            where: { id: boardId, creator: hostId },
        });
        if (!invitationOfHost.length && !boardOfCreator.length) {
            throw new ForbiddenError();
        }
        const invitation = {
            board: boardId,
            user: userId,
        };
        const createInvitation = this.invitationRepository.create(invitation);
        await this.invitationRepository.save(createInvitation);
    }
}
