import moment from 'moment-timezone';
import { BaseService } from './BaseService';
import { BoardService } from './BoardService';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';

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

    async getActivities(userId, boardId) {
        const board = await this.boardRepository.findOne(boardId);
        if (!board) throw new EntityNotFoundError();

        const boardService = BoardService.getInstance();
        await boardService.checkForbidden(userId, boardId);
        const activities = await this.activityRepository.find({
            where: { board: boardId },
            order: {
                createdAt: 'DESC',
            },
        });

        return activities.map((activity) => {
            return {
                ...activity,
                boardId,
                createdAt: moment(activity.createdAt)
                    .tz('Asia/Seoul')
                    .format('YYYY-MM-DD HH:mm:ss'),
            };
        });
    }
}
