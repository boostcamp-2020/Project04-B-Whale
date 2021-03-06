import { getNamespace } from 'cls-hooked';
import moment from 'moment-timezone';
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
        const [user, card] = await Promise.all([
            this.userRepository.findOne(userId),
            this.customCardRepository.findWithListAndBoardById(cardId),
        ]);

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
        const namespace = getNamespace('localstorage');
        namespace?.set('boardId', board.id);
        namespace?.set('cardTitle', (await this.cardRepository.findOne(cardId)).title);

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

        return {
            id: comment.id,
            content: comment.content,
            createdAt: moment(comment.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD HH:mm:ss'),
            user: {
                id: user.id,
                name: user.name,
                profileImageUrl: user.profileImageUrl,
            },
        };
    }

    @Transactional()
    async removeComment({ userId, commentId }) {
        const comment = await this.commentRepository.findOne(commentId, {
            loadRelationIds: {
                relations: ['user', 'card'],
                disableMixedMap: true,
            },
        });

        if (comment === undefined) {
            throw new EntityNotFoundError('Not found comment');
        }
        if (userId !== comment.user.id) {
            throw new ForbiddenError('Not your comment');
        }

        const namespace = getNamespace('localstorage');
        namespace?.set('userId', userId);
        namespace?.set(
            'boardId',
            (await this.customBoardRepository.findBoardByCommentId(commentId)).id,
        );

        await this.commentRepository.remove(comment);
    }

    @Transactional()
    async modifyComment({ userId, commentDto }) {
        const [user, comment] = await Promise.all([
            this.userRepository.findOne(userId),
            this.commentRepository.findOne(commentDto.id, {
                loadRelationIds: {
                    relations: ['user'],
                    disableMixedMap: true,
                },
            }),
        ]);

        if (comment === undefined) {
            throw new EntityNotFoundError('Not found comment');
        }

        if (userId !== comment.user.id) {
            throw new ForbiddenError('Not your comment');
        }

        if (!comment.updateContent(commentDto.content)) {
            return {
                id: comment.id,
                content: comment.content,
            };
        }

        await this.commentRepository.save(comment);

        return {
            id: comment.id,
            content: comment.content,
            createdAt: moment(comment.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD HH:mm:ss'),
            user: {
                id: user.id,
                name: user.name,
                profileImageUrl: user.profileImageUrl,
            },
        };
    }
}
