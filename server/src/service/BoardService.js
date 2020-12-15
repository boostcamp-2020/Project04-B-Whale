import { Transactional } from 'typeorm-transactional-cls-hooked';
import { createNamespace, getNamespace } from 'cls-hooked';
import { BaseService } from './BaseService';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { ForbiddenError } from '../common/error/ForbiddenError';
import { BadRequestError } from '../common/error/BadRequestError';

export class BoardService extends BaseService {
    static instance = null;

    static boardSpace = createNamespace('Board');

    static getInstance() {
        if (BoardService.instance === null) {
            BoardService.instance = new BoardService();
        }

        return BoardService.instance;
    }

    @Transactional()
    async getBoardsByUserId(userId) {
        const promises = [
            this.customBoardRepository.findByCreatorId(userId),
            this.customBoardRepository.findInvitedBoardsByUserId(userId),
        ];
        const [myBoards, invitedBoards] = await Promise.all(promises);

        return { myBoards, invitedBoards };
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

    async checkForbidden(hostId, boardId) {
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
    }

    @Transactional()
    async getDetailBoard(hostId, boardId) {
        const board = await this.boardRepository.findOne({
            select: ['id'],
            where: { id: boardId },
        });
        if (!board) throw new EntityNotFoundError();
        await this.checkForbidden(hostId, boardId);
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
            .orderBy('lists.position', 'ASC')
            .addOrderBy('cards.position', 'ASC')
            .getOne();
        if (Array.isArray(boardDetail?.invitations)) {
            boardDetail.invitedUsers = boardDetail.invitations.map((v) => v.user);
            delete boardDetail.invitations;
        }
        return boardDetail;
    }

    @Transactional()
    async inviteUserIntoBoard(hostId, boardId, userId) {
        await this.checkForbidden(hostId, boardId);
        if (hostId === userId) throw new BadRequestError(`Can't invite host.`);
        const invitedUsers = await this.invitationRepository.findOne({
            user: userId,
            board: boardId,
        });
        if (invitedUsers) throw new BadRequestError(`Duplicate user.`);
        const invitation = {
            board: boardId,
            user: userId,
        };
        const createInvitation = this.invitationRepository.create(invitation);
        await this.invitationRepository.save(createInvitation);
    }

    @Transactional()
    async updateBoard(hostId, boardId, title) {
        const board = await this.boardRepository.findOne(boardId);
        if (!board) throw new EntityNotFoundError();
        await this.checkForbidden(hostId, boardId);

        const boardNamespace = getNamespace('Board');
        boardNamespace.userId = hostId;

        board.title = title;
        await this.boardRepository.save(board);
    }
}
