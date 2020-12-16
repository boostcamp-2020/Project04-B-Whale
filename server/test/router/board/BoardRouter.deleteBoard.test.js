import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
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

    test('DELETE /api/board/:id 보드 삭제api 호출할 때, 보드 미존재시 404을 리턴한다.', async () => {
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
            const response = await request(app.httpServer).delete(`/api/board/${boardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(404);
        });
    });

    test('DELETE /api/board/:id 보드 삭제api 호출할 때, 삭제 권한이 없을 때 403을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user1 = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user1);
            await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createUser.id,
                username: createUser.name,
            });

            const user2 = { name: 'user2', socialId: '1234', profileImageUrl: 'image' };
            const createUser2 = userRepository.create(user2);
            await userRepository.save(createUser2);

            const boardRepository = getRepository(Board);
            const board = { title: 'board', creator: createUser2.id, color: '#ffffff' };
            const createBoard = boardRepository.create(board);
            await boardRepository.save(createBoard);

            // when
            const response = await request(app.httpServer)
                .delete(`/api/board/${createBoard.id}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            // then
            expect(response.status).toEqual(403);
        });
    });

    test('DELETE /api/board/:id 보드 삭제api 호출할 때, 정상 호출 시 204을 리턴한다.', async () => {
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
                .delete(`/api/board/${createBoard.id}`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                });

            expect(response.status).toEqual(204);
        });
    });
});
