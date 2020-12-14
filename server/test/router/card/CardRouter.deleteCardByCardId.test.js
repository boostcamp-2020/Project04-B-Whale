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

    test('DELETE /api/card/:id 카드 삭제api 호출할 때, 카드 미존재시 404을 리턴한다.', async () => {
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
            const cardId = 0;

            // when
            const response = await request(app.httpServer).delete(`/api/card/${cardId}`).set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(404);
        });
    });

    test('DELETE /api/card/:id 카드 삭제api 호출할 때, 정상 호출 시 204을 리턴한다.', async () => {
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

            expect(response.status).toEqual(204);
        });
    });
});
