import { EntityRepository } from 'typeorm';
import { BaseRepository } from 'typeorm-transactional-cls-hooked';
import { List } from '../model/List';

@EntityRepository(List)
export class CustomListRepository extends BaseRepository {
    async isListOfBoard({ boardId, listId }) {
        const lists = await this.createQueryBuilder('list')
            .innerJoin('list.board', 'board')
            .where('board.id=:boardId', { boardId })
            .andWhere('list.id=:listId', { listId })
            .getMany();

        return lists.length !== 0;
    }
}
