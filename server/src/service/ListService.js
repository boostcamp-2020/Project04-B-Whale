import { Transactional } from 'typeorm-transactional-cls-hooked';
import { createNamespace, getNamespace } from 'cls-hooked';
import { BaseService } from './BaseService';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { BoardService } from './BoardService';

export class ListService extends BaseService {
    static instance = null;

    static listSpace = createNamespace('List');

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
        const listNamespace = getNamespace('List');
        listNamespace.userId = userId;
        const list = await this.listRepository.findOne(listId, {
            loadRelationIds: {
                relations: ['board'],
                disableMixedMap: true,
            },
        });

        if (!list) throw new EntityNotFoundError();
        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, list.board.id);
        list.title = title || list.list_title;
        list.position = position || list.list_position;
        await this.listRepository.save(list);
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

        const listNamespace = getNamespace('List');
        listNamespace.userId = userId;
        listNamespace.boardId = list.board_id;

        await this.listRepository.remove(await this.listRepository.findOne(listId));
    }
}
