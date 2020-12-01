import { Transactional } from 'typeorm-transactional-cls-hooked';
import { BaseService } from './BaseService';

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
    async getDetailBoard(boardId) {
        const boardDetail = await this.boardRepository
            .createQueryBuilder('board')
            .innerJoin('board.creator', 'creator')
            .innerJoin('board.invitations', 'invitations')
            .innerJoin('invitations.user', 'user')
            .leftJoin('board.lists', 'lists')
            .leftJoin('lists.cards', 'cards')
            .leftJoin('cards.comments', 'comments')
            .select([
                'board',
                'creator.id',
                'creator.name',
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

        delete Object.assign(boardDetail, { invitedUsers: boardDetail.invitations }).invitations;
        boardDetail.invitedUsers = boardDetail.invitedUsers.map((v) => v.user);
        return boardDetail;
    }

    @Transactional()
    async inviteUserIntoBoard(boardId, userId) {
        const invitation = {
            board: boardId,
            user: userId,
        };
        const createInvitation = this.invitationRepository.create(invitation);
        await this.invitationRepository.save(createInvitation);
    }
}
