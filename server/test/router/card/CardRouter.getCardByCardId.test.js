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
import { Member } from '../../../src/model/Member';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('GET /api/card/:cardId', () => {
    let app = null;
    let jwtUtil = null;

    beforeAll(async () => {
        app = new Application();
        await app.initialize();
        jwtUtil = JwtUtil.getInstance();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('GET /api/card/{cardId} user0이 존재하지 않는 카드 id로 API 호출 시 404 반환', async () => {
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
                .get(`/api/card/1`)
                .set('Authorization', accessToken)
                .send();

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

    test('GET /api/card/{cardId} user1이 초대되지 않은 보드의 카드를 조회할 때 403 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'park-sooyeon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

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

            const accessToken = await jwtUtil.generateAccessToken({ userId: user1.id });

            // when
            const response = await agent(app.httpServer)
                .get(`/api/card/${card0.id}`)
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(403);
            expect(response.body).toEqual({
                error: {
                    code: 1003,
                    message: `You're not invited`,
                },
            });
        });
    });

    test('GET /api/card/{cardId} user0이 본인이 만든 card0을 조회하면 200 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'park-sooyeon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

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

            await em.save(em.create(Invitation, { user: user1, board: board0 }));
            await em.save(
                em.create(Member, {
                    user: user1,
                    card: card0,
                }),
            );

            const comment0 = em.create(Comment, {
                content: 'hey~',
                user: user1,
                card: card0,
            });
            await em.save(comment0);

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .get(`/api/card/${card0.id}`)
                .set('Authorization', accessToken)
                .send();

            expect(response.status).toEqual(200);
            expect(response.body).toEqual({
                id: card0.id,
                title: card0.title,
                content: card0.content,
                dueDate: card0.dueDate,
                position: card0.position,
                list: {
                    id: list0.id,
                    title: list0.title,
                },
                board: {
                    id: board0.id,
                    title: board0.title,
                },
                members: expect.any(Array),
                comments: expect.any(Array),
            });
            expect(response.body.members).toHaveLength(1);
            expect(response.body.members?.[0]).toEqual({
                id: user1.id,
                name: user1.name,
                profileImageUrl: user1.profileImageUrl,
            });
            expect(response.body.comments).toHaveLength(1);
            expect(response.body.comments?.[0]).toEqual({
                id: comment0.id,
                content: comment0.content,
                createdAt: moment(comment0.createdAt).tz('Asia/Seoul').format(),
                user: {
                    id: user1.id,
                    name: user1.name,
                    profileImageUrl: user1.profileImageUrl,
                },
            });
        });
    });
});
