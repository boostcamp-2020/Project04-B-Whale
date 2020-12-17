import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('DELETE /api/card/:cardId', () => {
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

    test('GET /api/activity?boardId={boardId} 보드별 액티비티 조회 api호출할 때, 보드 미존재시 404을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createUser.id,
                username: createUser.name,
            });
            const boardId = 0;

            // when
            const response = await request(app.httpServer)
                .get(`/api/activity?boardId=${boardId}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(404);
        });
    });

    test('GET /api/activity?boardId={boardId} 보드별 액티비티 조회 api호출할 때, 정상 호출 시 204을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
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

            // when
            const response = await request(app.httpServer)
                .get(`/api/activity?boardId=${createBoard.id}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            expect(response.status).toEqual(200);
        });
    });
});
