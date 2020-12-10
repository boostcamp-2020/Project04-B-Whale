import moment from 'moment-timezone';
import request, { agent } from 'supertest';
import { getRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { JwtUtil } from '../../src/common/util/JwtUtil';
import { Board } from '../../src/model/Board';
import { Card } from '../../src/model/Card';
import { Comment } from '../../src/model/Comment';
import { Invitation } from '../../src/model/Invitation';
import { List } from '../../src/model/List';
import { Member } from '../../src/model/Member';
import { User } from '../../src/model/User';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

describe('Card API Test', () => {
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

    test('GET /api/card/count를 호출할 때, Authorization header가 없으면 400을 리턴한다.', async () => {
        // given
        // when
        const response = await request(app.httpServer).get('/api/board').set({
            'Content-Type': 'application/json',
        });

        // then
        expect(response.status).toEqual(400);
    });

    test('GET /api/card/count를 호출할 때, 권한이 없으면 401을 리턴한다.', async () => {
        // given
        const token = 'Bearer fakeToken';

        // when
        const response = await request(app.httpServer).get('/api/board').set({
            Authorization: token,
            'Content-Type': 'application/json',
        });

        // then
        expect(response.status).toEqual(401);
    });

    test('GET /api/card/count를 호출할 때, queryString에 q변수가 없으면 400을 리턴한다.', async () => {
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

    test('GET /api/card/count를 호출할 때, q변수에 startDate, endDate 값이 하나라도 없으면 400을 리턴한다.', async () => {
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

    test(`GET /api/card/count를 호출할 때, q변수에 startDate, endDate의 format이 'yyyy-MM-dd'가 아니면 400을 리턴한다.`, async () => {
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

    test('GET /api/card/count를 호출할 때, q변수에 member가 me가 아니면 400을 리턴한다.', async () => {
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

    test(`GET /api/card/count?q=startdate:'yyyy-MM-dd' enddate:'yyyy-MM-dd'가 정상적으로 호출되었을 때, 200을 리턴한다.`, async () => {
        await TestTransactionDelegate.transaction(async () => {
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
        await TestTransactionDelegate.transaction(async () => {
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

    test('GET /api/card?q=date:2020-12-03 member:me', async () => {
        await TestTransactionDelegate.transaction(async () => {
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'dHoon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            await em.save(em.create(Invitation, { user: user1, board: board0 }));

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
                dueDate: moment('2020-12-03T21:00:00').format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 10,
                dueDate: moment('2020-12-03T22:00:00').format(),
                list: list0,
                creator: user1,
            });
            const card2 = em.create(Card, {
                title: 'card title 2',
                content: 'card content 2',
                position: 20,
                dueDate: moment('2020-12-03T23:00:00').format(),
                list: list0,
                creator: user1,
            });
            await em.save([card0, card1, card2]);

            await em.save([em.create(Member, { user: user0, card: card2 })]);

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .get('/api/card')
                .query({ q: `date:2020-12-03 member:me` })
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(200);
            expect(response.body.cards).toHaveLength(2);
            expect(response.body.cards?.[0]).toEqual(
                expect.objectContaining({
                    id: card0.id,
                    title: card0.title,
                    dueDate: moment(card0.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
            expect(response.body.cards?.[1]).toEqual(
                expect.objectContaining({
                    id: card2.id,
                    title: card2.title,
                    dueDate: moment(card2.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
        });
    });

    test('GET /api/card?q=date:2020-12-03', async () => {
        await TestTransactionDelegate.transaction(async () => {
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
            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            const board2 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            await em.save([board0, board1, board2]);

            await em.save([
                em.create(Invitation, {
                    user: user1,
                    board: board0,
                }),
                em.create(Invitation, {
                    user: user0,
                    board: board1,
                }),
            ]);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            const list1 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board1,
                creator: user1,
            });
            const list2 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board2,
                creator: user1,
            });
            await em.save([list0, list1, list2]);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment('2020-12-03T09:37:00').format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 0,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            const card2 = em.create(Card, {
                title: 'card title ',
                content: 'card content 2',
                position: 0,
                dueDate: moment('2020-12-03T17:27:00').format(),
                list: list2,
                creator: user1,
            });
            const card3 = em.create(Card, {
                title: 'card title 3',
                content: 'card content 3',
                position: 10,
                dueDate: moment('2020-12-03T18:59:00').format(),
                list: list2,
                creator: user1,
            });
            const card4 = em.create(Card, {
                title: 'card title 4',
                content: 'card content 4',
                position: 20,
                dueDate: moment('2020-12-01T11:11:00').format(),
                list: list0,
                creator: user1,
            });
            await em.save([card0, card1, card2, card3, card4]);

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .get('/api/card')
                .query({ q: `date:2020-12-03` })
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(200);
            expect(response.body.cards).toHaveLength(2);
            expect(response.body.cards?.[0]).toEqual(
                expect.objectContaining({
                    id: card0.id,
                    title: card0.title,
                    dueDate: moment(card0.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
            expect(response.body.cards?.[1]).toEqual(
                expect.objectContaining({
                    id: card1.id,
                    title: card1.title,
                    dueDate: moment(card1.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
        });
    });

    test('GET /api/card?q=date:2020-12-03 member:me', async () => {
        await TestTransactionDelegate.transaction(async () => {
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'dHoon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            await em.save(em.create(Invitation, { user: user1, board: board0 }));

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
                dueDate: moment('2020-12-03T21:00:00').format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 10,
                dueDate: moment('2020-12-03T22:00:00').format(),
                list: list0,
                creator: user1,
            });
            const card2 = em.create(Card, {
                title: 'card title 2',
                content: 'card content 2',
                position: 20,
                dueDate: moment('2020-12-03T23:00:00').format(),
                list: list0,
                creator: user1,
            });
            await em.save([card0, card1, card2]);

            await em.save([em.create(Member, { user: user0, card: card2 })]);

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .get('/api/card')
                .query({ q: `date:2020-12-03 member:me` })
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(200);
            expect(response.body.cards).toHaveLength(2);
            expect(response.body.cards?.[0]).toEqual(
                expect.objectContaining({
                    id: card0.id,
                    title: card0.title,
                    dueDate: moment(card0.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
            expect(response.body.cards?.[1]).toEqual(
                expect.objectContaining({
                    id: card2.id,
                    title: card2.title,
                    dueDate: moment(card2.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
        });
    });

    test('GET /api/card?q=date:2020-12-03', async () => {
        await TestTransactionDelegate.transaction(async () => {
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
            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            const board2 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            await em.save([board0, board1, board2]);

            await em.save([
                em.create(Invitation, {
                    user: user1,
                    board: board0,
                }),
                em.create(Invitation, {
                    user: user0,
                    board: board1,
                }),
            ]);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            const list1 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board1,
                creator: user1,
            });
            const list2 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board2,
                creator: user1,
            });
            await em.save([list0, list1, list2]);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment('2020-12-03T09:37:00').format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 0,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            const card2 = em.create(Card, {
                title: 'card title ',
                content: 'card content 2',
                position: 0,
                dueDate: moment('2020-12-03T17:27:00').format(),
                list: list2,
                creator: user1,
            });
            const card3 = em.create(Card, {
                title: 'card title 3',
                content: 'card content 3',
                position: 10,
                dueDate: moment('2020-12-03T18:59:00').format(),
                list: list2,
                creator: user1,
            });
            const card4 = em.create(Card, {
                title: 'card title 4',
                content: 'card content 4',
                position: 20,
                dueDate: moment('2020-12-01T11:11:00').format(),
                list: list0,
                creator: user1,
            });
            await em.save([card0, card1, card2, card3, card4]);

            const accessToken = await jwtUtil.generateAccessToken({ userId: user0.id });

            // when
            const response = await agent(app.httpServer)
                .get('/api/card')
                .query({ q: `date:2020-12-03` })
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(200);
            expect(response.body.cards).toHaveLength(2);
            expect(response.body.cards?.[0]).toEqual(
                expect.objectContaining({
                    id: card0.id,
                    title: card0.title,
                    dueDate: moment(card0.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
            expect(response.body.cards?.[1]).toEqual(
                expect.objectContaining({
                    id: card1.id,
                    title: card1.title,
                    dueDate: moment(card1.dueDate).tz('Asia/Seoul').format(),
                    commentCount: 0,
                }),
            );
        });
    });

    test('PATCH /api/card/{cardId} 호출할 때, 보드에 속한 리스트가 아닌 리스트로 옮기려하면 409 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('PATCH /api/card/{cardId} 호출할 때, 카드 수정 권한이 없으면 403 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('PATCH /api/card/{cardId} 호출할 때, 초대 되지 않은 보드의 카드를 수정하려면 403 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('PATCH /api/card/{cardId} 호출할 때, 카드가 존재하지 않으면 404 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('PATCH /api/card/{cardId} 호출이 성공하면 204 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('GET /api/card/{cardId} user0이 존재하지 않는 카드 id로 API 호출 시 404 반환', async () => {
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

    test('GET /api/card/{cardId} user1이 초대되지 않은 보드의 카드를 조회할 때 403 반환', async () => {
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

    test('GET /api/card/{cardId} user0이 본인이 만든 card0을 조회하면 200 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('DELETE /api/card/:id 카드 삭제api 호출할 때, 카드 미존재시 404을 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createUser.id,
                username: createUser.name,
            });
            const cardId = 0;
            // when
            const response = await request(app.httpServer).delete(`/api/card/${cardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });
        });
    });

    test('PUT /api/card/{cardId}/member 요청시, 멤버 변경 권한이 없으면 403 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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
            const userIds = [user1.id, user2.id];

            // when
            const response = await agent(app.httpServer)
                .put(`/api/card/${cardId}/member`)
                .set('Authorization', token)
                .send({ userIds });

            // then
            expect(response.status).toEqual(403);
        });
    });

    test('PUT /api/card/{cardId}/member 요청시, 멤버를 추가할 카드가 없으면 404 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('DELETE /api/card/:id 카드 삭제api 호출할 때, 정상 호출 시 204을 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'dh', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createUser.id,
                username: createUser.name,
            });

            const boardRepository = getRepository(Board);
            const board = { title: 'board', creator: createUser.id, color: '#ffffff' };
            const createBoard = boardRepository.create(board);
            await boardRepository.save(createBoard);

            const listRepository = getRepository(List);
            const list = {
                title: 'list',
                creator: createUser.id,
                position: 1,
                board: createBoard.id,
            };
            const createList = listRepository.create(list);
            await listRepository.save(createList);

            const cardRepository = getRepository(Card);
            const card = {
                title: 'card',
                creator: createUser.id,
                position: 1,
                content: 'card detail',
                dueDate: '2020-12-31 00:00:00',
                list: createList.id,
                board: createBoard.id,
            };
            const createCard = cardRepository.create(card);
            await cardRepository.save(createCard);

            // when
            const response = await request(app.httpServer)
                .delete(`/api/card/${createCard.id}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });
        });
    });

    test('PUT /api/card/{cardId}/member 요청시, 추가될 멤버가 보드에 속한 멤버가 아니면 409 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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

    test('PUT /api/card/{cardId}/member 요청 성공 시, 204 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
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
