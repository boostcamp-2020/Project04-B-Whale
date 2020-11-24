import { BaseService } from './BaseService';

export class ActivityService extends BaseService {
    static instance = null;

    static getInstance() {
        if (ActivityService.instance === null) {
            ActivityService.instance = new ActivityService();
        }

        return ActivityService.instance;
    }
}
