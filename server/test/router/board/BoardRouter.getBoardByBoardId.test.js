import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('GET /api/board/:boardId', () => {
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

    test('보드에 대한 권한이 없으면 401을 리턴한다', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            const token = 'Bearer fakeToken';
            const boardId = 1;
            const response = await request(app.httpServer).get(`/api/board/${boardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });
            expect(response.status).toEqual(401);
        });
    });

    test('보드 미존재 시 404 리턴.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
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

    test('정상적으로 호출되었을 때, 200을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
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
});
