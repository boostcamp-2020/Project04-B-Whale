import { BaseService } from './BaseService';

export class ActivityService extends BaseService {
    static instance = null;

    static getInstance() {
        if (ActivityService.instance === null) {
            ActivityService.instance = new ActivityService();
        }

        return ActivityService.instance;
    }

    async createActivity(boardId, content) {
        const activity = {
            board: boardId,
            content,
        };
        const createActivity = this.activityRepository.create(activity);
        await this.activityRepository.save(createActivity);
    }
}
