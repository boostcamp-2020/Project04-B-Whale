import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../src/Application';
import { JwtUtil } from '../../src/common/util/JwtUtil';
import { Board } from '../../src/model/Board';
import { Invitation } from '../../src/model/Invitation';
import { User } from '../../src/model/User';

describe('Board API Test', () => {
    let app = null;
    let jwtUtil = null;

    beforeAll(async () => {
        const newApp = new Application();
        await newApp.initialize();
        app = newApp;
        jwtUtil = JwtUtil.getInstance();
    });

    test('GET /api/board를 호출할 때, Authorization header가 없으면 400을 리턴한다.', async () => {
        // given
        // when
        const response = await request(app.httpServer).get('/api/board').set({
            'Content-Type': 'application/json',
        });

        // then
        expect(response.status).toEqual(400);
    });

    test('GET /api/board를 호출할 때, 권한이 없으면 401을 리턴한다.', async () => {
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

    test('GET /api/board가 정상적으로 호출되었을 때, 200을 리턴한다.', async () => {
        // given
        const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };
        const user2 = { name: 'user2', socialId: '1244', profileImageUrl: 'image' };

        const userRepository = getRepository(User);
        const createUser1 = await userRepository.create(user1);
        const createUser2 = await userRepository.create(user2);
        const [createdUser1, createdUser2] = await userRepository.save([createUser1, createUser2]);

        const token = await jwtUtil.generateAccessToken({
            userId: createdUser2.id,
            username: createdUser2.name,
        });

        const boardRepository = getRepository(Board);
        const board1 = { id: 1, title: 'board1', creator: createdUser1.id };
        const board2 = { id: 2, title: 'board2', creator: createdUser2.id };
        const createBoard1 = await boardRepository.create(board1);
        const createBoard2 = await boardRepository.create(board2);
        const [createdBoard1] = await boardRepository.save([createBoard1, createBoard2]);

        const invitationRepository = getRepository(Invitation);
        const invitedBoard = { user: createdUser2.id, board: createdBoard1.id };
        const createInvitedBoard = await invitationRepository.create(invitedBoard);
        await invitationRepository.save(createInvitedBoard);

        // when
        const response = await request(app.httpServer).get('/api/board').set({
            Authorization: token,
            'Content-Type': 'application/json',
        });

        // then
        expect(response.status).toEqual(200);
        const { myBoards, invitedBoards } = response.body;
        expect(myBoards).toHaveLength(1);
        expect(invitedBoards).toHaveLength(1);
    });

    test('POST /api/board를 호출할 때, 요청 바디가 올바르지 않으면 400을 리턴한다.', async () => {
        // given
        // when
        const response = await request(app.httpServer).post('/api/board').send({ title: null });

        // then
        expect(response.status).toEqual(400);
    });

    test('POST /api/board를 호출할 때, 권한이 없으면 401을 리턴한다.', async () => {
        // given
        const token = 'Bearer fakeToken';

        // when
        const response = await request(app.httpServer).post('/api/board').set({
            Authorization: token,
            'Content-Type': 'application/json',
        });

        // then
        expect(response.status).toEqual(401);
    });

    test('GET /api/board가 정상적으로 호출되었을 때, 201을 리턴한다.', async () => {
        // given
        const testTitle = 'test title';
        const boardRepository = getRepository(Board);
        const countOfBoardFirst = await boardRepository
            .createQueryBuilder('board')
            .select('board.id')
            .addSelect('board.title')
            .where('board.title = :title', { title: testTitle })
            .getCount();

        const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };

        const userRepository = getRepository(User);
        const createUser = await userRepository.create(user);
        const createdUser = await userRepository.save(createUser);

        const token = await jwtUtil.generateAccessToken({
            userId: createdUser.id,
            username: createdUser.name,
        });

        // when
        const response = await request(app.httpServer)
            .post('/api/board')
            .set({
                Authorization: token,
                'Content-Type': 'application/json',
            })
            .send({ title: testTitle });

        const countOfBoardSecond = await boardRepository
            .createQueryBuilder('board')
            .select('board.id')
            .addSelect('board.title')
            .where('board.title = :title', { title: testTitle })
            .getCount();

        // then
        expect(response.status).toEqual(201);
        expect(countOfBoardFirst).toEqual(countOfBoardSecond - 1);
    });
});
