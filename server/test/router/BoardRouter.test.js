import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../src/Application';
import { JwtUtil } from '../../src/common/util/JwtUtil';
import { Board } from '../../src/model/Board';
import { Invitation } from '../../src/model/Invitation';
import { User } from '../../src/model/User';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

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
        const createUser1 = userRepository.create(user1);
        const createUser2 = userRepository.create(user2);
        const [createdUser1, createdUser2] = await userRepository.save([createUser1, createUser2]);

        const token = await jwtUtil.generateAccessToken({
            userId: createdUser2.id,
            username: createdUser2.name,
        });

        const boardRepository = getRepository(Board);
        const board1 = { id: 1, title: 'board1', creator: createdUser1.id, color: '#000000' };
        const board2 = { id: 2, title: 'board2', creator: createdUser2.id, color: '#000000' };
        const createBoard1 = boardRepository.create(board1);
        const createBoard2 = boardRepository.create(board2);
        const [createdBoard1] = await boardRepository.save([createBoard1, createBoard2]);

        const invitationRepository = getRepository(Invitation);
        const invitedBoard = { user: createdUser2.id, board: createdBoard1.id };
        const createInvitedBoard = invitationRepository.create(invitedBoard);
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
        await TestTransactionDelegate.transaction(async () => {
            // given
            // when
            const response = await request(app.httpServer).post('/api/board').send({ title: null });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test('POST /api/board를 호출할 때, 권한이 없으면 401을 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
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
    });

    test('POST /api/board가 정상적으로 호출되었을 때, 201을 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
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
                .send({ title: 'test title', color: '#000000', creator: createdUser.id });

            // then
            expect(response.status).toEqual(201);
        });
    });

    test('GET /api/board/{boardId} 호출 시, 권한이 없으면 401을 리턴한다', async () => {
        await TestTransactionDelegate.transaction(async () => {
            const token = 'Bearer fakeToken';
            const boardId = 1;
            const response = await request(app.httpServer).get(`/api/board/${boardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });
            expect(response.status).toEqual(401);
        });
    });

    test('GET /api/board/{boardId} 호출 시, 보드 미존재 시 404 리턴.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });
            const boardId = 0;
            const response = await request(app.httpServer).get(`/api/board/${boardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            expect(response.status).toEqual(404);
        });
    });

    test('GET /api/board/{boardId}가 정상적으로 호출되었을 때, 200을 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);

            const boardRepository = getRepository(Board);
            const board = { title: 'board', creator: createdUser.id, color: '#000000' };
            const createBoard = boardRepository.create(board);
            const createdBoard = await boardRepository.save(createBoard);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });

            const boardId = createdBoard.id;
            const response = await request(app.httpServer).get(`/api/board/${boardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });
            expect(response.status).toEqual(200);
        });
    });

    test('put /api/board/{boardId}가 정상적으로 호출되었을 때(권한o, 보드o), 204 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'dhoooon', socialId: 'naver-1', profileImageUrl: 'dhoon-amg' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);

            const boardRepository = getRepository(Board);
            const board = { title: 'board', creator: createdUser.id, color: '#ffffff' };
            const createBoard = boardRepository.create(board);
            await boardRepository.save(createBoard);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });
            const boardId = createBoard.id;

            // when
            const response = await request(app.httpServer).put(`/api/board/${boardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(204);
        });
    });

    test('POST /api/board/{boardId}/list 호출 시, 보드 미존재 시 404 리턴.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            const user = { name: 'dhoon', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });
            const boardId = 0;
            const response = await request(app.httpServer).post(`/api/board/${boardId}/list`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });
            expect(response.status).toEqual(404);
        });
    });

    test('리스트 생성 POST /api/board/{boardId}/list 가 정상적으로 호출되었을 때(권한o, 보드o), 201 리턴한다.', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'dhoooon', socialId: 'naver-1', profileImageUrl: 'dhoon-amg' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);

            const boardRepository = getRepository(Board);
            const board = { title: 'board', creator: createdUser.id, color: '#ffffff' };
            const createBoard = boardRepository.create(board);
            await boardRepository.save(createBoard);

            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });
            const boardId = createBoard.id;

            // when
            const response = await request(app.httpServer)
                .post(`/api/board/${boardId}/list`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                })
                .send({ title: 'dh-list', position: '1', creator: createdUser.id, board: boardId });

            // then
            expect(response.status).toEqual(201);
        });
    });
});
