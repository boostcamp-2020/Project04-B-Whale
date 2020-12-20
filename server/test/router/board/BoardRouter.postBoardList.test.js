import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('POST /api/board/:boardId/list', () => {
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

    test('POST /api/board/:boardId/list 호출 시, 보드 미존재 시 404 리턴.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
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

    test('리스트 생성 POST /api/board/:boardId/list 가 정상적으로 호출되었을 때(권한o, 보드o), 201 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
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
