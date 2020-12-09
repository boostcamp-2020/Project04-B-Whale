import { Transactional } from 'typeorm-transactional-cls-hooked';
import { EntityNotFoundError } from '../common/error/EntityNotFoundError';
import { ForbiddenError } from '../common/error/ForbiddenError';
import { BaseService } from './BaseService';

export class CommentService extends BaseService {
    static instance = null;

    static getInstance() {
        if (CommentService.instance === null) {
            CommentService.instance = new CommentService();
        }

        return CommentService.instance;
    }

    @Transactional()
    async addComment({ userId, cardId, content }) {
        const card = await this.customCardRepository.findWithListAndBoardById(cardId);

        if (card === undefined) {
            throw new EntityNotFoundError('Not found card');
        }

        const { list } = card;
        const { board } = list;

        const isAuthorized = await this.customBoardRepository.existUserByBoardId({
            boardId: board.id,
            userId,
        });

        if (!isAuthorized) {
            throw new ForbiddenError(`You're not authorized`);
        }

        const comment = this.commentRepository.create({
            content,
            user: {
                id: userId,
            },
            card: {
                id: card.id,
            },
        });
        await this.commentRepository.save(comment);

        return comment;
    }

    @Transactional()
    async removeComment({ userId, commentId }) {
        const comment = await this.commentRepository.findOne(commentId, {
            loadRelationIds: {
                relations: ['user'],
                disableMixedMap: true,
            },
        });

        if (comment === undefined) {
            throw new EntityNotFoundError('Not found comment');
        }
        if (userId !== comment.user.id) {
            throw new ForbiddenError('Not your comment');
        }

        await this.commentRepository.remove(comment);
    }

    @Transactional()
    async modifyComment({ userId, commentId, commentDto }) {
        const comment = await this.commentRepository.findOne(commentId, {
            loadRelationIds: {
                relations: ['user'],
                disableMixedMap: true,
            },
        });

        if (comment === undefined) {
            throw new EntityNotFoundError('Not found comment');
        }
        if (userId !== comment.user.id) {
            throw new ForbiddenError('Not your comment');
        }

        if (comment.content === commentDto.content) {
            return;
        }

        comment.updateContent(commentDto.content);
        await this.commentRepository.save(comment);
    }
}
