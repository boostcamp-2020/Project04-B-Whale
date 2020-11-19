import { AbstractService } from './AbstractService';

export class ActivityService extends AbstractService {
    static instance = null;

    static getInstance() {
        if (ActivityService.instance === null) {
            ActivityService.instance = new ActivityService();
        }

        return ActivityService.instance;
    }
}
