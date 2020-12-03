import moment from 'moment';
import { getRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { Board } from '../../src/model/Board';
import { Card } from '../../src/model/Card';
import { Invitation } from '../../src/model/Invitation';
import { List } from '../../src/model/List';
import { Member } from '../../src/model/Member';
import { User } from '../../src/model/User';
import { CardService } from '../../src/service/CardService';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

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

    test('getMyCardsByDueDate(): user0이 생성한 카드와 멤버로 할당된 카드 중 dueDate가 2020-12-03인 카드 목록 조회', async () => {
        const cardService = CardService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'dHoon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            await em.save(em.create(Invitation, { user: user1, board: board0 }));

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            await em.save(list0);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment('2020-12-03T21:00:00').format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 10,
                dueDate: moment('2020-12-03T22:00:00').format(),
                list: list0,
                creator: user1,
            });
            const card2 = em.create(Card, {
                title: 'card title 2',
                content: 'card content 2',
                position: 20,
                dueDate: moment('2020-12-03T23:00:00').format(),
                list: list0,
                creator: user1,
            });
            await em.save([card0, card1, card2]);

            await em.save([em.create(Member, { user: user0, card: card2 })]);

            // when
            const cards = await cardService.getMyCardsByDueDate({
                userId: user0.id,
                dueDate: moment('2020-12-03').format('YYYY-MM-DD'),
            });

            // then
            expect(cards).toHaveLength(2);
            expect(cards[0]).toEqual(expect.objectContaining({ id: card0.id }));
            expect(cards[1]).toEqual(expect.objectContaining({ id: card2.id }));
        });
    });

    test('getMyCardsByDueDate(): user0이 생성한 카드와 멤버로 할당된 카드가 없을 때 빈 배열 반환', async () => {
        const cardService = CardService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);

            // when
            const cards = await cardService.getMyCardsByDueDate({
                userId: user0.id,
                dueDate: moment('2020-12-03').format('YYYY-MM-DD'),
            });

            // then
            expect(cards).toHaveLength(0);
        });
    });

    test('getAllCardsByDueDate(): user0이 생성한 보드와 초대된 보드의 카드 중 dueDate가 2020-12-03인 카드 조회', async () => {
        const cardService = CardService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'park-sooyeon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            const board2 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            await em.save([board0, board1, board2]);

            await em.save([
                em.create(Invitation, {
                    user: user1,
                    board: board0,
                }),
                em.create(Invitation, {
                    user: user0,
                    board: board1,
                }),
            ]);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            const list1 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board1,
                creator: user1,
            });
            const list2 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board2,
                creator: user1,
            });
            await em.save([list0, list1, list2]);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment('2020-12-03T09:37:00').format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 0,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            const card2 = em.create(Card, {
                title: 'card title ',
                content: 'card content 2',
                position: 0,
                dueDate: moment('2020-12-03T17:27:00').format(),
                list: list2,
                creator: user1,
            });
            const card3 = em.create(Card, {
                title: 'card title 3',
                content: 'card content 3',
                position: 10,
                dueDate: moment('2020-12-03T18:59:00').format(),
                list: list2,
                creator: user1,
            });
            const card4 = em.create(Card, {
                title: 'card title 4',
                content: 'card content 4',
                position: 20,
                dueDate: moment('2020-12-01T11:11:00').format(),
                list: list0,
                creator: user1,
            });
            await em.save([card0, card1, card2, card3, card4]);

            // when
            const cards = await cardService.getAllCardsByDueDate({
                userId: user0.id,
                dueDate: '2020-12-03',
            });

            // then
            expect(cards).toHaveLength(2);
            expect(cards[0]).toEqual(expect.objectContaining({ id: card0.id }));
            expect(cards[1]).toEqual(expect.objectContaining({ id: card1.id }));
        });
    });
});
