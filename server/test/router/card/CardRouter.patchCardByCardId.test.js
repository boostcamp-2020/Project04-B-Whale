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

describe('PATCH /api/card/:cardId', () => {
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

    test('보드에 속한 리스트가 아닌 리스트로 옮기려하면 409 반환', async () => {
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
            const board2 = em.create(Board, {
                title: 'board title 2',
                color: '#FF0000',
                creator: user1,
            });
            await em.save([board1, board2]);

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            const list2 = em.create(List, {
                title: 'list title 2',
                position: 1,
                board: board2,
                creator: user1,
            });
            await em.save([list1, list2]);

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
            const updateData = {
                listId: list2.id,
                title: 'card update title',
                content: 'card update content',
                position: 2,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/card/${cardId}`)
                .set('Authorization', token)
                .send(updateData);

            // then
            expect(response.status).toEqual(409);
        });
    });

    test('카드 수정 권한이 없으면 403 반환', async () => {
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

            const token = await jwtUtil.generateAccessToken({ userId: user2.id });
            const cardId = card1.id;
            const updateData = {
                listId: undefined,
                title: 'card update title',
                content: 'card update content',
                position: 2,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/card/${cardId}`)
                .set('Authorization', token)
                .send(updateData);

            // then
            expect(response.status).toEqual(403);
        });
    });

    test('초대 되지 않은 보드의 카드를 수정하려면 403 반환', async () => {
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
            const board2 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save([board1, board2]);

            em.save(Invitation, { user: user2, board: board2 });

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

            const token = await jwtUtil.generateAccessToken({ userId: user2.id });
            const cardId = card1.id;
            const updateData = {
                listId: undefined,
                title: 'card update title',
                content: 'card update content',
                position: 2,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/card/${cardId}`)
                .set('Authorization', token)
                .send(updateData);

            // then
            expect(response.status).toEqual(403);
        });
    });

    test('카드가 존재하지 않으면 404 반환', async () => {
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
            const updateData = {
                listId: undefined,
                title: 'card update title',
                content: 'card update content',
                position: 2,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/card/${cardId}`)
                .set('Authorization', token)
                .send(updateData);

            // then
            expect(response.status).toEqual(404);
        });
    });

    test('호출이 성공하면 204 반환', async () => {
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
            const cardId = card1.id;
            const updateData = {
                listId: undefined,
                title: 'card update title',
                content: 'card update content',
                position: 2,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            const response = await agent(app.httpServer)
                .patch(`/api/card/${cardId}`)
                .set('Authorization', token)
                .send(updateData);

            // then
            expect(response.status).toEqual(204);
        });
    });
});
