import { BaseService } from './BaseService';

export class UserService extends BaseService {
    static instance = null;

    static getInstance() {
        if (UserService.instance === null) {
            UserService.instance = new UserService();
        }

        return UserService.instance;
    }
}
