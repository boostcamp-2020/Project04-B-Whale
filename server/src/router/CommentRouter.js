import { plainToClass } from 'class-transformer';
import { isNumberString, validateOrReject } from 'class-validator';
import { Router } from 'express';
import { BadRequestError } from '../common/error/BadRequestError';
import { CommentDto } from '../dto/CommentDto';
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

    router.patch('/:commentId', async (req, res) => {
        const userId = req.user.id;
        const commentDto = plainToClass(
            CommentDto,
            {
                id: req.params.commentId,
                ...req.body,
            },
            { excludeExtraneousValues: true },
        );

        await validateOrReject(commentDto, { groups: ['MODIFY_COMMENT'] });

        const responseBody = await commentService.modifyComment({
            userId,
            commentDto,
        });
        res.status(200).json(responseBody);
    });

    return router;
};
