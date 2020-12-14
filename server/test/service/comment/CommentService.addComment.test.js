import moment from 'moment';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { EntityNotFoundError } from '../../../src/common/error/EntityNotFoundError';
import { ForbiddenError } from '../../../src/common/error/ForbiddenError';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { CommentService } from '../../../src/service/CommentService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CommentService.addComment() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('없는 카드에 대해 댓글을 작성할 때 EntityNotFoundError 발생', async () => {
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

            // when
            // then
            try {
                await commentService.addComment({
                    userId: user0.id,
                    cardId: 1,
                    content: 'whats up',
                });
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(EntityNotFoundError);
                expect(error.message).toEqual('Not found card');
            }
        });
    });

    test('user0이 카드에 댓글을 남기려 하지만 보드에 초대되지 않아서 ForBiddenError 발생', async () => {
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

            // when
            // then
            try {
                await commentService.addComment({
                    userId: user0.id,
                    cardId: card0.id,
                    content: 'edited card content 0',
                });
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(ForbiddenError);
                expect(error.message).toEqual(`You're not authorized`);
            }
        });
    });

    test('user0이 card0에 댓글을 남긴다', async () => {
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

            await em.save(
                em.create(Invitation, {
                    user: user0,
                    board: board0,
                }),
            );

            // when
            const comment = await commentService.addComment({
                userId: user0.id,
                cardId: card0.id,
                content: 'edited card content 0',
            });

            // then
            expect(comment.id).toEqual(expect.any(Number));
            expect(comment.content).toEqual(`edited card content 0`);
        });
    });
});
