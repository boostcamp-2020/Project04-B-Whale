import { AbstractService } from './AbstractService';

export class UserService extends AbstractService {
    static instance = null;

    static getInstance() {
        if (UserService.instance === null) {
            UserService.instance = new UserService();
        }

        return UserService.instance;
    }
}
