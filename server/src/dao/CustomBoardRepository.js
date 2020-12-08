import { EntityRepository } from 'typeorm';
import { BaseRepository } from 'typeorm-transactional-cls-hooked';
import { Board } from '../model/Board';

@EntityRepository(Board)
export class CustomBoardRepository extends BaseRepository {
    async findByCreatorId(creatorId) {
        const boards = await this.find({ creator: { id: creatorId } });
        return boards;
    }

    async findInvitedBoardsByUserId(userId) {
        const boards = await this.createQueryBuilder('a')
            .innerJoin('a.invitations', 'b')
            .where('b.user.id = :userId', { userId })
            .getMany();
        return boards;
    }

    async findBoardIdsByUserId(userId) {
        const boards = await this.createQueryBuilder('board')
            .select('board.id', 'id')
            .leftJoin('board.invitations', 'invitation')
            .where(`board.creator_id=:userId or invitation.user_id=:userId`, { userId })
            .getRawMany();

        const boardIds = boards.map((ele) => ele.id);

        return boardIds;
    }

    async findBoardByCardId(cardId) {
        const board = await this.createQueryBuilder('board')
            .innerJoin('board.lists', 'list')
            .innerJoin('list.cards', 'card')
            .where('card.id=:cardId', { cardId })
            .getOne();

        return board;
    }

    async existUserByBoardId({ boardId, userId }) {
        const isAuth = await this.createQueryBuilder('board')
            .leftJoin('board.invitations', 'invitation')
            .where('board.id=:boardId', { boardId })
            .andWhere('(board.creator_id=:userId OR invitation.user_id=:userId)', { userId })
            .getMany();

        return isAuth.length !== 0;
    }

    async existListByBoardId({ boardId, listId }) {
        const lists = await this.createQueryBuilder('board')
            .innerJoin('board.lists', 'list')
            .where('board.id=:boardId', { boardId })
            .andWhere('list.id=:listId', { listId })
            .getMany();

        return lists.length !== 0;
    }
}
