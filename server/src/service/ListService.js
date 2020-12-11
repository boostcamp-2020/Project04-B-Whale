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
    async createList(userId, boardId, title) {
        const boardService = BoardService.getInstance();
        const board = await this.boardRepository.findOne({
            select: ['id'],
            where: { id: boardId },
        });
        if (!board) throw new EntityNotFoundError();
        await boardService.checkForbidden(userId, boardId);
        const listWithMaxPosition = await this.listRepository
            .createQueryBuilder('list')
            .select('MAX(list.position)', 'max_position')
            .where('list.board = :boardId', { boardId })
            .getRawOne();

        const maxPosition = listWithMaxPosition.max_position;
        const list = this.listRepository.create({
            creator: userId,
            board: boardId,
            position: maxPosition + 1,
            title,
        });
        await this.listRepository.save(list);
        return {
            id: list.id,
            title: list.title,
            position: list.position,
        };
    }

    @Transactional()
    async updateList({ userId, listId, position, title }) {
        const list = await this.listRepository
            .createQueryBuilder('list')
            .where('list.id = :listId', { listId })
            .getRawOne();
        if (!list) throw new EntityNotFoundError();
        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, list.list_board_id);
        const updatedList = {
            title: title || list.list_title,
            position: position || list.list_position,
            board: list.list_board_id,
            creator: list.list_creator_id,
        };
        await this.listRepository.update({ id: listId }, updatedList);
    }

    @Transactional()
    async deleteList({ userId, listId }) {
        const list = await this.listRepository
            .createQueryBuilder('list')
            .select(['list.board'])
            .where('list.id = :listId', { listId })
            .getRawOne();
        if (!list) throw new EntityNotFoundError();
        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, list.board_id);
        await this.listRepository.delete(listId);
    }
}
