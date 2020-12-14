import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { BoardService } from '../../../src/service/BoardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('BoardService.getDetailBoard() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('보드 상세 조회 서비스 정상 호출', async () => {
        const boardService = BoardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            const user = { name: 'user', socialId: '1234111', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save([createUser]);

            const board = { title: 'board title', color: '#0000ff', creator: createUser.id };
            const boardRepository = getRepository(Board);
            const createBoard = boardRepository.create(board);
            await boardRepository.save([createBoard]);

            const invitationRepository = getRepository(Invitation);
            const invitation = { board: createBoard.id, user: createUser.id };
            const createInvitation = invitationRepository.create(invitation);
            await invitationRepository.save([createInvitation]);

            const list = {
                title: 'test to do',
                position: 1,
                board: createBoard.id,
                creator: createUser.id,
            };
            const listRepository = getRepository(List);
            const createList = listRepository.create(list);
            await listRepository.save([createList]);

            const card = {
                title: 'test card',
                content: 'test content',
                position: 1,
                dueDate: '2020-01-01',
                list: createList.id,
                creator: createUser.id,
            };
            const cardRepository = getRepository(Card);
            const createCard = cardRepository.create(card);
            await cardRepository.save([createCard]);
            const detailBoard = await boardService.getDetailBoard(createUser.id, createBoard.id);
            const compareData = {
                id: createBoard.id,
                title: 'board title',
                color: '#0000ff',
                creator: {
                    id: createUser.id,
                    name: 'user',
                    profileImageUrl: 'image',
                },
                lists: [
                    {
                        id: createList.id,
                        title: 'test to do',
                        position: 1,
                        cards: [
                            {
                                id: createCard.id,
                                title: 'test card',
                                position: 1,
                                dueDate: '2020-01-01T00:00:00.000Z',
                                commentCount: 0,
                            },
                        ],
                    },
                ],
                invitedUsers: [
                    {
                        id: createUser.id,
                        name: 'user',
                        profileImageUrl: 'image',
                    },
                ],
            };
            expect(JSON.stringify(compareData)).toEqual(JSON.stringify(detailBoard));
        });
    });
});
