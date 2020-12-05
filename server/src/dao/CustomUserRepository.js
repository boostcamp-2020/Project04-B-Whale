import { EntityRepository } from 'typeorm';
import { BaseRepository } from 'typeorm-transactional-cls-hooked';
import { User } from '../model/User';

@EntityRepository(User)
export class CustomUserRepository extends BaseRepository {
    async findUserNameById(userId) {
        const boards = await this.findOne(userId);
        return boards.name;
    }
}
