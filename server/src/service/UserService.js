import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { BaseService } from './BaseService';

export class UserService extends BaseService {
    static instance = null;

    static getInstance() {
        if (UserService.instance === null) {
            UserService.instance = new UserService();
        }

        return UserService.instance;
    }

    async getUserById(userId) {
        const user = await this.userRepository.findOne(userId);

        if (user === undefined) {
            throw new EntityNotFoundError(`No user that has the userId ${userId}`);
        }

        return user;
    }

    async getUserStartsWithName(userName) {
        const user = await this.userRepository
            .createQueryBuilder('user')
            .select(['user.id', 'user.name', 'user.profileImageUrl'])
            .where('user.name like :name', { name: `${userName}%` })
            .getMany();
        return user;
    }
}
