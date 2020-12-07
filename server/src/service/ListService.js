import { Transactional } from 'typeorm-transactional-cls-hooked';
import { BaseService } from './BaseService';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { BoardService } from './BoardService';

export class ListService extends BaseService {
    static instance = null;

    static getInstance() {
        if (ListService.instance === null) {
            ListService.instance = new ListService();
        }

        return ListService.instance;
    }

    @Transactional()
    async createList(userId, boardId, position, title) {
        const boardService = BoardService.getInstance();
        const board = await this.boardRepository.findOne({
            select: ['id'],
            where: { id: boardId },
        });
        if (!board) throw new EntityNotFoundError();
        await boardService.checkForbidden(userId, boardId);
        const list = {
            creator: userId,
            board: boardId,
            position,
            title,
        };
        const createList = this.listRepository.create(list);
        await this.listRepository.save(createList);
    }

    @Transactional()
    async updateList(userId, listId, position, title) {
        const list = await this.listRepository
            .createQueryBuilder('list')
            .where('list.id = :listId', { listId })
            .getRawOne();
        if (!list) throw new EntityNotFoundError();
        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, list.list_board_id);
        const updatedList = {
            title,
            position,
            board: list.list_board_id,
            creator: list.list_creator_id,
        };
        await this.listRepository.update({ id: list.list_id }, updatedList);
    }
}
