import { getRepository } from 'typeorm';
import { TestTransactionDelegate } from '../TestTransactionDelegate';
import { Application } from '../../src/Application';
import { Board } from '../../src/model/Board';
import { List } from '../../src/model/List';
import { User } from '../../src/model/User';
import { ListService } from '../../src/service/ListService';

describe('Board Service Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('리스트 수정 서비스 함수 updateList 테스트', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'dhoon', socialId: '1234111', profileImageUrl: 'dh-image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save([createUser]);

            const board = { title: 'board of dh', color: '#aa00ff', creator: createUser.id };
            const boardRepository = getRepository(Board);
            const createBoard = boardRepository.create(board);
            await boardRepository.save([createBoard]);

            const list = {
                title: 'dh-list',
                position: 1,
                board: createBoard.id,
                creator: createUser.id,
            };
            const listRepository = getRepository(List);
            const createList = listRepository.create(list);
            await listRepository.save([createList]);

            // when
            const listService = ListService.getInstance();
            const config = {
                userId: createUser.id,
                listId: createList.id,
                position: 2,
                title: 'list2',
            };
            await listService.updateList(config);
            const updatedList = await listRepository.findOne(createList.id);

            // then
            expect(updatedList.title).toEqual('list2');
            expect(updatedList.position).toEqual(2);
        });
    });

    test('리스트 삭제 서비스 함수 deleteList 테스트', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'dhoon', socialId: '1234111', profileImageUrl: 'dh-image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save([createUser]);

            const board = { title: 'board of dh', color: '#aa00ff', creator: createUser.id };
            const boardRepository = getRepository(Board);
            const createBoard = boardRepository.create(board);
            await boardRepository.save([createBoard]);

            const list = {
                title: 'dh-list',
                position: 1,
                board: createBoard.id,
                creator: createUser.id,
            };
            const listRepository = getRepository(List);
            const createList = listRepository.create(list);
            await listRepository.save([createList]);

            // when
            const listService = ListService.getInstance();
            await listService.deleteList({ userId: createUser.id, listId: createList.id });
            const deleteList = await listRepository.findOne(createList.id);

            // then
            expect(deleteList).toEqual(undefined);
        });
    });
});
