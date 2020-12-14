import moment from 'moment-timezone';
import { agent } from 'supertest';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('POST /api/card/:cardId/comment', () => {
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

    test('존재하지 않는 카드 id로 API 호출 시 404 반환', async () => {
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
                .post(`/api/card/1/comment`)
                .set('Authorization', accessToken)
                .send({
                    content: 'comment content',
                });

            // then
            expect(response.status).toEqual(404);
            expect(response.body).toEqual({
                error: {
                    code: 1000,
                    message: 'Not found card',
                },
            });
        });
    });

    test('user0이 카드에 댓글을 남기려 하지만 보드에 초대되지 않아서 ForBiddenError 발생', async () => {
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

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .post(`/api/card/${card0.id}/comment`)
                .set('Authorization', accessToken)
                .send({
                    content: 'comment content',
                });

            // then
            expect(response.status).toEqual(403);
            expect(response.body).toEqual({
                error: {
                    code: 1003,
                    message: `You're not authorized`,
                },
            });
        });
    });

    test('잘못된 형식의 카드 id로 요청했을 때 400 반환', async () => {
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
                .post(`/api/card/dd/comment`)
                .set('Authorization', accessToken)
                .send({
                    content: 'comment content',
                });

            // then
            expect(response.status).toEqual(400);
            expect(response.body).toEqual({
                error: {
                    code: 1004,
                    message: 'Wrong params',
                },
            });
        });
    });

    test('Request body에 아무것도 없으면 400 반환', async () => {
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
                .post(`/api/card/1/comment`)
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(400);
            expect(response.body).toEqual({
                error: {
                    code: 1004,
                    message: 'Empty content',
                },
            });
        });
    });

    test('user0이 card0에 대해 댓글 작성 201 반환', async () => {
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

            await em.save(em.create(Invitation, { user: user0, board: board0 }));

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .post(`/api/card/${card0.id}/comment`)
                .set('Authorization', accessToken)
                .send({ content: 'this is a comment' });

            // then
            expect(response.status).toEqual(201);
        });
    });
});
