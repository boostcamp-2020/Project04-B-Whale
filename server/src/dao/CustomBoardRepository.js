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
}
