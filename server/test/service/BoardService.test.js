const { getRepository } = require('typeorm');
const { Application } = require('../../src/Application');
const { Board } = require('../../src/model/Board');
const { Card } = require('../../src/model/Card');
const { Invitation } = require('../../src/model/Invitation');
const { List } = require('../../src/model/List');
const { Member } = require('../../src/model/Member');
const { User } = require('../../src/model/User');
const { BoardService } = require('../../src/service/BoardService');

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

    test('보드 상세 조회 서비스 정상 호출', async () => {
        const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
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

        const list = { title: 'test to do', position: 1, board: createBoard.id };
        const listRepository = getRepository(List);
        const createList = listRepository.create(list);
        await listRepository.save([createList]);

        const card = {
            title: 'test card',
            content: 'test content',
            position: 1,
            dueDate: '2020-01-01',
            list: createList.id,
        };
        const cardRepository = getRepository(Card);
        const createCard = cardRepository.create(card);
        await cardRepository.save([createCard]);

        const BoardService1 = BoardService.getInstance();
        const detailBoard = await BoardService1.getDetailBoard(createBoard.id);

        const compareData = {
            id: createBoard.id,
            title: 'board title',
            color: '#0000ff',
            creator: {
                id: createUser.id,
                name: 'user',
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
