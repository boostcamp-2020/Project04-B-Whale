const { getRepository } = require('typeorm');
const { Application } = require('../../src/Application');
const { Board } = require('../../src/model/Board');
const { Card } = require('../../src/model/Card');
const { List } = require('../../src/model/List');
const { Member } = require('../../src/model/Member');
const { User } = require('../../src/model/User');
const { CardService } = require('../../src/service/CardService');

describe('Card Service Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    beforeEach(async () => {});

    test('정상적인 사용자가 startDate, endDate 기간동안의 모든 카드 조회', async () => {
        // given
        const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };

        const userRepository = getRepository(User);
        const createUser1 = userRepository.create(user1);
        await userRepository.save([createUser1]);

        const board1 = { title: 'board title', color: '#0000ff', creator: createUser1.id };

        const boardRepository = getRepository(Board);
        const createBoard1 = boardRepository.create(board1);
        await boardRepository.save([createBoard1]);

        const list1 = { title: 'list title', position: 1, board: createBoard1.id };

        const listRepository = getRepository(List);
        const createList1 = listRepository.create(list1);
        await listRepository.save([createList1]);

        const cardRepository = getRepository(Card);

        const cardPromises = [];
        let position = 1;
        const cardData1 = { dueDate: '2020-07-07', count: 2 };
        const cardData2 = { dueDate: '2020-07-10', count: 5 };
        const cardData3 = { dueDate: '2020-07-15', count: 3 };
        for (let i = 0; i < cardData1.count; i += 1) {
            const card = cardRepository.create({
                title: 'card title',
                content: 'card content',
                position,
                dueDate: cardData1.dueDate,
                list: createList1.id,
            });
            position += 1;
            cardPromises.push(cardRepository.save(card));
        }
        for (let i = 0; i < cardData2.count; i += 1) {
            const card = cardRepository.create({
                title: 'card title',
                content: 'card content',
                position,
                dueDate: cardData2.dueDate,
                list: createList1.id,
            });
            position += 1;
            cardPromises.push(cardRepository.save(card));
        }
        for (let i = 0; i < cardData3.count; i += 1) {
            const card = cardRepository.create({
                title: 'card title',
                content: 'card content',
                position,
                dueDate: cardData3.dueDate,
                list: createList1.id,
            });
            position += 1;
            cardPromises.push(cardRepository.save(card));
        }

        await Promise.all(cardPromises);

        // when
        const cardService = CardService.getInstance();
        const cardCountList = await cardService.getCardCountByPeriod({
            startDate: '2020-07-01',
            endDate: '2020-07-31',
            boardIds: [createBoard1.id],
        });

        // then
        const [data1, data2, data3] = cardCountList;
        expect(data1).toEqual(cardData1);
        expect(data2).toEqual(cardData2);
        expect(data3).toEqual(cardData3);
    });

    test('정상적인 사용자가 startDate, endDate 기간동안의 member에 속한 카드 조회', async () => {
        // given
        const user1 = { name: 'user1', socialId: '1234', profileImageUrl: 'image' };

        const userRepository = getRepository(User);
        const createUser1 = userRepository.create(user1);
        await userRepository.save([createUser1]);

        const board1 = { title: 'board title', color: '#0000ff', creator: createUser1.id };

        const boardRepository = getRepository(Board);
        const createBoard1 = boardRepository.create(board1);
        await boardRepository.save([createBoard1]);

        const list1 = { title: 'list title', position: 1, board: createBoard1.id };

        const listRepository = getRepository(List);
        const createList1 = listRepository.create(list1);
        await listRepository.save([createList1]);

        const cardRepository = getRepository(Card);

        const cardPromises = [];
        let position = 1;
        const cardData1 = { dueDate: '2020-07-07', count: 2 };
        for (let i = 0; i < cardData1.count; i += 1) {
            const card = cardRepository.create({
                title: 'card title',
                content: 'card content',
                position,
                dueDate: cardData1.dueDate,
                list: createList1.id,
            });
            position += 1;
            cardPromises.push(cardRepository.save(card));
        }

        const [card1Info] = await Promise.all(cardPromises);

        const memberRepository = getRepository(Member);
        const member1 = { user: createUser1.id, card: card1Info.id };
        const createMember1 = memberRepository.create(member1);
        await memberRepository.save(createMember1);

        // when
        const cardService = CardService.getInstance();
        const cardCountList = await cardService.getCardCountByPeriod({
            startDate: '2020-07-01',
            endDate: '2020-07-31',
            boardIds: [createBoard1.id],
            userId: createUser1.id,
        });

        // then
        const [data1] = cardCountList;
        expect(data1).toEqual({ ...cardData1, count: 1 });
    });
});
