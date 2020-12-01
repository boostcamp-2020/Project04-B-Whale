import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../src/Application';
import { JwtUtil } from '../../src/common/util/JwtUtil';
import { Board } from '../../src/model/Board';
import { Card } from '../../src/model/Card';
import { Invitation } from '../../src/model/Invitation';
import { List } from '../../src/model/List';
import { Member } from '../../src/model/Member';
import { User } from '../../src/model/User';

describe('Board API Test', () => {
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

    test(`GET /api/card/count?q=startdate:'yyyy-MM-dd' enddate:'yyyy-MM-dd'가 정상적으로 호출되었을 때, 200을 리턴한다.`, async () => {
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
        const list1 = { title: 'list1', position: 1, board: createBoard1.id };
        const list2 = { title: 'list2', position: 1, board: createBoard2.id };
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
            });
            position += 1;
            cardPromises.push(cardRepository.save(card));
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

    test(`GET /api/card/count?q=startdate:'yyyy-MM-dd' enddate:'yyyy-MM-dd' member:me가 정상적으로 호출되었을 때, 200을 리턴한다.`, async () => {
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
        const list1 = { title: 'list1', position: 1, board: createBoard1.id };
        const list2 = { title: 'list2', position: 1, board: createBoard2.id };
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
        const response = await request(app.httpServer)
            .get(`/api/card/count?q=startdate:${startDate} enddate:${endDate} member:me`)
            .set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

        // then
        expect(response.status).toEqual(200);
        const { cardCounts } = response.body;
        expect(cardCounts).toHaveLength(1);
    });
});
