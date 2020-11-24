import { BaseService } from './BaseService';

export class ListService extends BaseService {
    static instance = null;

    static getInstance() {
        if (ListService.instance === null) {
            ListService.instance = new ListService();
        }

        return ListService.instance;
    }
}
