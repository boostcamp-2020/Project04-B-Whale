import { Router } from 'express';
import passport from 'passport';
import { UserService } from '../service/UserService';

export const UserRouter = () => {
    const router = Router();

    router.get('/me', passport.authenticate('jwt', { session: false }), async (req, res) => {
        const userService = UserService.getInstance();
        const user = await userService.getUserById(req?.user?.id);
        res.status(200).json({
            id: user.id,
            name: user.name,
            profileImageUrl: user.profileImageUrl,
        });
    });

    return router;
};
