const { getRepository } = require('typeorm');
const { getEntityManagerOrTransactionManager } = require('typeorm-transactional-cls-hooked');
const { Application } = require('../../src/Application');
const { Board } = require('../../src/model/Board');
const { Card } = require('../../src/model/Card');
const { List } = require('../../src/model/List');
const { Member } = require('../../src/model/Member');
const { User } = require('../../src/model/User');
const { CardService } = require('../../src/service/CardService');
const { TestTransactionDelegate } = require('../TestTransactionDelegate');

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
        const cardRepository = getRepository(Card);
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'user1',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            await em.save(user1);

            const board1 = em.create(Board, {
                title: 'board title',
                color: '#0000ff',
                creator: user1.id,
            });
            await em.save(board1);

            const list1 = em.create(List, {
                title: 'list title',
                position: 1,
                board: board1.id,
                creator: user1,
            });
            await em.save([list1]);

            const cardPromises = [];
            let position = 1;
            const cardData1 = { dueDate: '2020-07-07', count: 2 };
            const cardData2 = { dueDate: '2020-07-10', count: 5 };
            const cardData3 = { dueDate: '2020-07-15', count: 3 };
            for (let i = 0; i < cardData1.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData1.dueDate,
                    list: list1.id,
                    creator: user1,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }
            for (let i = 0; i < cardData2.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData2.dueDate,
                    list: list1.id,
                    creator: user1,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }
            for (let i = 0; i < cardData3.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData3.dueDate,
                    list: list1.id,
                    creator: user1,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }

            await Promise.all(cardPromises);

            // when
            const cardService = CardService.getInstance();
            const cardCountList = await cardService.getCardCountByPeriod({
                startDate: '2020-07-01',
                endDate: '2020-07-31',
                userId: user1.id,
            });

            // then
            const [data1, data2, data3] = cardCountList;
            expect(data1).toEqual(cardData1);
            expect(data2).toEqual(cardData2);
            expect(data3).toEqual(cardData3);
        });
    });

    test('로그인 중인 정상적인 사용자가 startDate, endDate 기간동안의 member에 속한 카드 조회', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'user1',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            await em.save(user1);

            const board1 = em.create(Board, {
                title: 'board title',
                color: '#0000ff',
                creator: user1.id,
            });
            await em.save(board1);

            const list1 = em.create(List, {
                title: 'list title',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const cardPromises = [];
            let position = 1;
            const cardData1 = { dueDate: '2020-07-07', count: 2 };
            for (let i = 0; i < cardData1.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData1.dueDate,
                    list: list1,
                    creator: user1,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }

            const [card1Info] = await Promise.all(cardPromises);

            await em.save(em.create(Member, { user: user1, card: card1Info }));

            // when
            const cardService = CardService.getInstance();
            const cardCountList = await cardService.getCardCountByPeriod({
                startDate: '2020-07-01',
                endDate: '2020-07-31',
                userId: user1.id,
                member: 'me',
            });

            // then
            const [data1] = cardCountList;
            expect(data1).toEqual({ ...cardData1, count: 1 });
        });
    });
});
