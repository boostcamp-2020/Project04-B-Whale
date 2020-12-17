import { Router } from 'express';
import { ActivityService } from '../service/ActivityService';

export const ActivityRouter = () => {
    const router = Router();

    router.get('/', async (req, res) => {
        const activityService = ActivityService.getInstance();
        const { boardId } = req.query;
        const activities = await activityService.getActivities(req.user.id, +boardId);
        res.status(200).json({ activities });
    });

    return router;
};
