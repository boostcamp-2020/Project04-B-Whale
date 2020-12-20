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

describe('PUT /api/card/:cardId/member', () => {
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

    test('PUT /api/card/:cardId/member 요청시, 멤버를 추가할 카드가 없으면 404 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            await em.save(user1);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            const token = await jwtUtil.generateAccessToken({ userId: user1.id });
            const cardId = 0;
            const userIds = [user1.id];

            // when
            const response = await agent(app.httpServer)
                .put(`/api/card/${cardId}/member`)
                .set('Authorization', token)
                .send({ userIds });

            // then
            expect(response.status).toEqual(404);
        });
    });

    test('PUT /api/card/:cardId/member 요청시, 추가될 멤버가 보드에 속한 멤버가 아니면 409 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            const user2 = em.create(User, {
                socialId: '2',
                name: 'user2',
                profileImageUrl: 'image2',
            });
            const user3 = em.create(User, {
                socialId: '3',
                name: 'user3',
                profileImageUrl: 'image3',
            });
            await em.save([user1, user2, user3]);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            await em.save(em.create(Invitation, { user: user2, board: board1 }));

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            const token = await jwtUtil.generateAccessToken({ userId: user1.id });
            const cardId = card1.id;
            const userIds = [user1.id, user3.id];

            // when
            const response = await agent(app.httpServer)
                .put(`/api/card/${cardId}/member`)
                .set('Authorization', token)
                .send({ userIds });

            // then
            expect(response.status).toEqual(409);
        });
    });

    test('PUT /api/card/:cardId/member 요청 성공 시, 204 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            const user2 = em.create(User, {
                socialId: '2',
                name: 'user2',
                profileImageUrl: 'image2',
            });
            await em.save([user1, user2]);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            await em.save(em.create(Invitation, { user: user2, board: board1 }));

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            const token = await jwtUtil.generateAccessToken({ userId: user1.id });
            const cardId = card1.id;
            const userIds = [user1.id, user2.id];

            // when
            const response = await agent(app.httpServer)
                .put(`/api/card/${cardId}/member`)
                .set('Authorization', token)
                .send({ userIds });

            // then
            expect(response.status).toEqual(204);
        });
    });
});
