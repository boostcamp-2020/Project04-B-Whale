import moment from 'moment';
import { getRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { EntityNotFoundError } from '../../../src/common/error/EntityNotFoundError';
import { ForbiddenError } from '../../../src/common/error/ForbiddenError';
import { CommentDto } from '../../../src/dto/CommentDto';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Comment } from '../../../src/model/Comment';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { CommentService } from '../../../src/service/CommentService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CommentService.modifyComment() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('존재하지 않는 댓글을 수정할 때 EntityNotFoundError 발생', async () => {
        const commentService = CommentService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);

            const commentDto = new CommentDto(1, 'edited content');

            // when
            // then
            try {
                await commentService.removeComment({ userId: user0.id, commentDto });
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(EntityNotFoundError);
                expect(error.message).toEqual('Not found comment');
            }
        });
    });

    test('댓글을 수정하려고 하지만 본인 댓글이 아니라서 ForBiddenError 발생', async () => {
        const commentService = CommentService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: 1,
                name: 'sooyeon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user1,
            });
            await em.save(board0);

            await em.save(em.create(Invitation, { user: user0, board: board0 }));

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user1,
            });
            await em.save(list0);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment.tz('2020-12-03T09:37:00', 'Asia/Seoul').format(),
                list: list0,
                creator: user1,
            });
            await em.save(card0);

            const comment0 = em.create(Comment, {
                content: 'comment content',
                card: card0,
                user: user1,
            });
            await em.save(comment0);

            const commentDto = new CommentDto(comment0.id, 'edited content');

            // when
            // then
            try {
                await commentService.modifyComment({
                    userId: user0.id,
                    commentDto,
                });
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(ForbiddenError);
                expect(error.message).toEqual(`Not your comment`);
            }
        });
    });

    test('댓글 내용이 같아서 데이터베이스에 접근하지 않음', async () => {
        const commentService = CommentService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            await em.save(list0);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment.tz('2020-12-03T09:37:00', 'Asia/Seoul').format(),
                list: list0,
                creator: user0,
            });
            await em.save(card0);

            const comment0 = em.create(Comment, {
                content: 'comment content 0',
                card: card0,
                user: user0,
            });
            await em.save(comment0);

            const commentRequestDto = new CommentDto(comment0.id, 'comment content 0');
            const commentRepositorySpy = jest.spyOn(getRepository(Comment), 'save');

            // when
            const commentResponseDto = await commentService.modifyComment({
                userId: user0.id,
                commentDto: commentRequestDto,
            });

            // then
            expect(commentResponseDto).toEqual({
                id: commentRequestDto.id,
                content: commentRequestDto.content,
            });
            expect(commentRepositorySpy).not.toHaveBeenCalled();

            commentRepositorySpy.mockRestore();
        });
    });

    test('본인이 작성한 댓글 수정', async () => {
        const commentService = CommentService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            await em.save(list0);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment.tz('2020-12-03T09:37:00', 'Asia/Seoul').format(),
                list: list0,
                creator: user0,
            });
            await em.save(card0);

            const comment0 = em.create(Comment, {
                content: 'comment content',
                card: card0,
                user: user0,
            });
            await em.save(comment0);

            const commentRequestDto = new CommentDto(comment0.id, 'edited content');

            // when
            const commentResponseDto = await commentService.modifyComment({
                userId: user0.id,
                commentDto: commentRequestDto,
            });

            // then
            expect(commentResponseDto).toEqual({
                id: commentRequestDto.id,
                content: commentRequestDto.content,
                createdAt: expect.anything(),
                user: {
                    id: user0.id,
                    name: user0.name,
                    profileImageUrl: user0.profileImageUrl,
                },
            });
        });
    });
});
