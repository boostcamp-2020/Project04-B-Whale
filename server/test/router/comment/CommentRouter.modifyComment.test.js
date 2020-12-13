import moment from 'moment-timezone';
import { agent } from 'supertest';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Comment } from '../../../src/model/Comment';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('PATCH /api/comment/{commentId}', () => {
    const app = new Application();
    let jwtUtil = null;

    beforeAll(async () => {
        await app.initialize();
        jwtUtil = JwtUtil.getInstance();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('존재하지 않는 댓글을 수정할 때 404 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);
            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });
            // when
            const response = await agent(app.httpServer)
                .patch(`/api/comment/1`)
                .set('Authorization', accessToken)
                .send({
                    content: 'edited content',
                });
            // then
            expect(response.status).toEqual(404);
        });
    });

    test('commentId가 문자열일 때 호출 시 400 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);
            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/comment/dd`)
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(400);
        });
    });

    test('본인 댓글이 아닌 댓글을 수정할 때 403 반환', async () => {
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

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });
            const expectedContent = 'edited content';

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/comment/${comment0.id}`)
                .set('Authorization', accessToken)
                .send({
                    content: expectedContent,
                });

            // then
            expect(response.status).toEqual(403);
        });
    });

    test('본인이 작성한 댓글 삭제 성공 시 204 반환', async () => {
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

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });
            const expectedContent = 'edited content';

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/comment/${comment0.id}`)
                .set('Authorization', accessToken)
                .send({ content: expectedContent });

            // then
            expect(response.status).toEqual(204);
        });
    });
});
