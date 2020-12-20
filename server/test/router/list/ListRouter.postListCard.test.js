import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { Board } from '../../../src/model/Board';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('POST /api/list/:listId/card', () => {
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

    test('POST /api/list/:listId/card 카드 추가 api 호출 시, 리스트 존재하지 않을 때, 404 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user = { name: 'dhoon', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });
            const listId = 0;

            // when
            const response = await request(app.httpServer).post(`/api/list/${listId}/card`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(404);
        });
    });

    test('POST /api/list/:listId/card 카드 추가 api 호출 시, 정상호출 시, 201 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user = { name: 'dhoon', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
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

            // when
            const response = await request(app.httpServer)
                .post(`/api/list/${createList.id}/card`)
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                })
                .send({
                    title: 'card title',
                    dueDate: '2020-12-31 00:00:00',
                    position: 1,
                    content: 'card detail',
                });

            // then
            expect(response.status).toEqual(201);
            expect(response.body).toEqual({
                id: expect.any(Number),
                title: 'card title',
                position: 1,
                content: 'card detail',
                dueDate: '2020-12-31 00:00:00',
            });
        });
    });
});
