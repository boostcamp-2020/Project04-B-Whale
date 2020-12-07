import { Router } from 'express';
import { UserService } from '../service/UserService';

export const UserRouter = () => {
    const router = Router();

    router.get('/me', async (req, res) => {
        const userService = UserService.getInstance();
        const user = await userService.getUserById(req?.user?.id);
        res.status(200).json({
            id: user.id,
            name: user.name,
            profileImageUrl: user.profileImageUrl,
        });
    });

    router.get('/', async (req, res) => {
        const userService = UserService.getInstance();
        const userName = req.query?.username;
        if (userName === undefined) {
            return res.sendStatus(400);
        }
        const user = await userService.getUserStartsWithName(userName);
        res.status(200).json(user);
    });

    return router;
};
