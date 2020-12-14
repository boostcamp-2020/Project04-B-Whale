import request from 'supertest';
import { getRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { Member } from '../../../src/model/Member';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('GET /api/card/count', () => {
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

    test('queryString에 q변수가 없으면 400을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };

            const userRepository = getRepository(User);
            const createUser1 = userRepository.create(user1);
            await userRepository.save([createUser1]);

            const token = await jwtUtil.generateAccessToken({
                userId: createUser1.id,
                username: createUser1.name,
            });

            // when
            const response = await request(app.httpServer).get(`/api/card/count`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test('q변수에 startDate, endDate 값이 하나라도 없으면 400을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };

            const userRepository = getRepository(User);
            const createUser1 = userRepository.create(user1);
            await userRepository.save([createUser1]);

            const token = await jwtUtil.generateAccessToken({
                userId: createUser1.id,
                username: createUser1.name,
            });

            // when
            const startDate = '2020-07-01';
            const response = await request(app.httpServer)
                .get(`/api/card/count?q=startdate:${startDate}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test(`q변수에 startDate, endDate의 format이 'yyyy-MM-dd'가 아니면 400을 리턴한다.`, async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };

            const userRepository = getRepository(User);
            const createUser1 = userRepository.create(user1);
            await userRepository.save([createUser1]);

            const token = await jwtUtil.generateAccessToken({
                userId: createUser1.id,
                username: createUser1.name,
            });

            // when
            const startDate = '2020-7-1';
            const endDate = '2020-7-31';
            const response = await request(app.httpServer)
                .get(`/api/card/count?q=startdate:${startDate} enddate:${endDate}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test('GET /api/card/count를 호출할 때, q변수에 member가 me가 아니면 400을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };

            const userRepository = getRepository(User);
            const createUser1 = userRepository.create(user1);
            await userRepository.save([createUser1]);

            const token = await jwtUtil.generateAccessToken({
                userId: createUser1.id,
                username: createUser1.name,
            });

            // when
            const startDate = '2020-07-01';
            const endDate = '2020-07-31';
            const member = 'other';
            const response = await request(app.httpServer)
                .get(`/api/card/count?q=startdate:${startDate} enddate:${endDate} member:${member}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test(`GET /api/card/count?q=startdate:'yyyy-MM-dd' enddate:'yyyy-MM-dd'가 정상적으로 호출되었을 때, 200을 리턴한다.`, async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'user1',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            const user2 = em.create(User, {
                name: 'user2',
                socialId: '1244',
                profileImageUrl: 'image',
            });
            await em.save([user1, user2]);

            const token = await jwtUtil.generateAccessToken({
                userId: user2.id,
                username: user2.name,
            });

            const board1 = em.create(Board, {
                title: 'board1',
                creator: user1,
                color: '#000000',
            });
            const board2 = em.create(Board, {
                title: 'board2',
                creator: user2,
                color: '#000000',
            });
            await em.save([board1, board2]);

            const invitedBoard = em.create(Invitation, { user: user2.id, board: board1.id });
            await em.save(invitedBoard);

            const list1 = em.create(List, {
                title: 'list1',
                position: 1,
                board: board1.id,
                creator: user1,
            });
            const list2 = em.create(List, {
                title: 'list2',
                position: 1,
                board: board2.id,
                creator: user2,
            });
            await em.save([list1, list2]);

            const cardPromises = [];
            let position = 1;
            const cardData1 = { dueDate: '2020-07-07', count: 2 };
            const cardData2 = { dueDate: '2020-07-10', count: 5 };
            for (let i = 0; i < cardData1.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData1.dueDate,
                    list: list1,
                    creator: user1,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }
            for (let i = 0; i < cardData2.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData2.dueDate,
                    list: list2,
                    creator: user2,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }

            await Promise.all(cardPromises);

            // when
            const startDate = '2020-07-01';
            const endDate = '2020-07-31';
            const response = await request(app.httpServer)
                .get(`/api/card/count?q=startdate:${startDate} enddate:${endDate}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(200);
            const { cardCounts } = response.body;
            expect(cardCounts).toHaveLength(2);
        });
    });

    test(`GET /api/card/count?q=startdate:'yyyy-MM-dd' enddate:'yyyy-MM-dd' member:me가 정상적으로 호출되었을 때, 200을 리턴한다.`, async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };
            const user2 = { name: 'user2', socialId: '1244', profileImageUrl: 'image' };

            const userRepository = getRepository(User);
            const createUser1 = userRepository.create(user1);
            const createUser2 = userRepository.create(user2);
            await userRepository.save([createUser1, createUser2]);

            const token = await jwtUtil.generateAccessToken({
                userId: createUser2.id,
                username: createUser2.name,
            });

            const boardRepository = getRepository(Board);
            const board1 = { id: 1, title: 'board1', creator: createUser1.id, color: '#000000' };
            const board2 = { id: 2, title: 'board2', creator: createUser2.id, color: '#000000' };
            const createBoard1 = boardRepository.create(board1);
            const createBoard2 = boardRepository.create(board2);
            await boardRepository.save([createBoard1, createBoard2]);

            const invitationRepository = getRepository(Invitation);
            const invitedBoard = { user: createUser2.id, board: createBoard1.id };
            const createInvitedBoard = invitationRepository.create(invitedBoard);
            await invitationRepository.save(createInvitedBoard);

            const listRepository = getRepository(List);
            const list1 = {
                title: 'list1',
                position: 1,
                board: createBoard1.id,
                creator: createUser1,
            };
            const list2 = {
                title: 'list2',
                position: 1,
                board: createBoard2.id,
                creator: createUser2,
            };
            const createList1 = listRepository.create(list1);
            const createList2 = listRepository.create(list2);
            await listRepository.save([createList1, createList2]);

            const cardRepository = getRepository(Card);

            const cardPromises = [];
            let position = 1;
            const cardData1 = { dueDate: '2020-07-07', count: 2 };
            const cardData2 = { dueDate: '2020-07-10', count: 5 };
            for (let i = 0; i < cardData1.count; i += 1) {
                const card = cardRepository.create({
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData1.dueDate,
                    list: createList1.id,
                    creator: createUser1,
                });
                position += 1;
                cardPromises.push(cardRepository.save(card));
            }
            for (let i = 0; i < cardData2.count; i += 1) {
                const card = cardRepository.create({
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData2.dueDate,
                    list: createList2.id,
                    creator: createUser2,
                });
                position += 1;
                cardPromises.push(cardRepository.save(card));
            }

            const [card1Info] = await Promise.all(cardPromises);

            const memberRepository = getRepository(Member);
            const member1 = { user: createUser2.id, card: card1Info.id };
            const createMember1 = memberRepository.create(member1);
            await memberRepository.save(createMember1);

            // when
            const startDate = '2020-07-01';
            const endDate = '2020-07-31';
            const member = 'me';
            const response = await request(app.httpServer)
                .get(`/api/card/count?q=startdate:${startDate} enddate:${endDate} member:${member}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(200);
            const { cardCounts } = response.body;
            expect(cardCounts).toHaveLength(2);
        });
    });
});
