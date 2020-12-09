import { isNumberString } from 'class-validator';
import { Router } from 'express';
import { BadRequestError } from '../common/error/BadRequestError';
import { CommentService } from '../service/CommentService';

export const CommentRouter = () => {
    const router = Router();

    const commentService = CommentService.getInstance();

    router.delete('/:commentId', async (req, res) => {
        const userId = req.user.id;
        const { commentId } = req.params;

        if (commentId === undefined || !isNumberString(commentId)) {
            throw new BadRequestError('Wrong commentId');
        }

        await commentService.removeComment({ userId, commentId: parseInt(commentId, 10) });

        res.status(204).end();
    });

    return router;
};
