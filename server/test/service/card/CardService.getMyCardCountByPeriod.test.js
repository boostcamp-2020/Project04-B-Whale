import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { Member } from '../../../src/model/Member';
import { User } from '../../../src/model/User';
import { CardService } from '../../../src/service/CardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CardService.getMyCardCountByPeriod() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('로그인 중인 정상적인 사용자가 startDate, endDate 기간동안의 member에 속하거나 생성한 카드 조회', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'user1',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            const user2 = em.create(User, {
                name: 'user2',
                socialId: '12345',
                profileImageUrl: 'image',
            });
            await em.save([user1, user2]);

            const board1 = em.create(Board, {
                title: 'board title',
                color: '#0000ff',
                creator: user1.id,
            });
            await em.save(board1);

            await em.save(em.create(Invitation, { user: user2, board: board1 }));

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
            const cardData2 = { dueDate: '2020-07-09', count: 3 };
            const cardData3 = { dueDate: '2020-08-07', count: 1 };
            for (let i = 0; i < cardData1.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData1.dueDate,
                    list: list1,
                    creator: user2,
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
                    list: list1,
                    creator: user1,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }
            const card = em.create(Card, {
                title: 'card title',
                content: 'card content',
                position,
                dueDate: cardData3.dueDate,
                list: list1,
                creator: user1,
            });
            cardPromises.push(em.save(card));

            const [card1Info] = await Promise.all(cardPromises);

            await em.save(em.create(Member, { user: user1, card }));
            await em.save(em.create(Member, { user: user1, card: card1Info }));

            // when
            const cardService = CardService.getInstance();
            const cardCountList = await cardService.getMyCardCountByPeriod({
                startDate: '2020-07-01',
                endDate: '2020-07-31',
                userId: user1.id,
                member: 'me',
            });

            // then
            expect(cardCountList).toHaveLength(2);
            const [data1, data2] = cardCountList;
            expect(data1).toEqual({ ...cardData1, count: 1 });
            expect(data2).toEqual(cardData2);
        });
    });

    test('정상적인 사용자가 만든 카드에 member가 여러명인 경우, startDate, endDate 기간동안의 사용자가 member에 속하는 카드 개수만 조회', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'user1',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            const user2 = em.create(User, {
                name: 'user2',
                socialId: '12345',
                profileImageUrl: 'image',
            });
            const user3 = em.create(User, {
                name: 'user3',
                socialId: '123456',
                profileImageUrl: 'image',
            });
            await em.save([user1, user2, user3]);

            const board1 = em.create(Board, {
                title: 'board title',
                color: '#0000ff',
                creator: user1.id,
            });
            await em.save(board1);

            await em.save(em.create(Invitation, { user: user2, board: board1 }));

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
            const cardData2 = { dueDate: '2020-07-09', count: 3 };
            const cardData3 = { dueDate: '2020-08-07', count: 1 };
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
            for (let i = 0; i < cardData2.count; i += 1) {
                const card = em.create(Card, {
                    title: 'card title',
                    content: 'card content',
                    position,
                    dueDate: cardData2.dueDate,
                    list: list1,
                    creator: user2,
                });
                position += 1;
                cardPromises.push(em.save(card));
            }
            const card = em.create(Card, {
                title: 'card title',
                content: 'card content',
                position,
                dueDate: cardData3.dueDate,
                list: list1,
                creator: user3,
            });
            cardPromises.push(em.save(card));

            const cards = await Promise.all(cardPromises);

            await em.save(em.create(Member, { user: user1, card }));
            await em.save(em.create(Member, { user: user1, card: cards[3] }));
            await em.save(em.create(Member, { user: user1, card: cards[0] }));
            await em.save(em.create(Member, { user: user2, card: cards[0] }));
            await em.save(em.create(Member, { user: user3, card: cards[0] }));

            // when
            const cardService = CardService.getInstance();
            const cardCountList = await cardService.getMyCardCountByPeriod({
                startDate: '2020-07-01',
                endDate: '2020-07-31',
                userId: user1.id,
                member: 'me',
            });

            // then
            expect(cardCountList).toHaveLength(2);
            const [data1, data2] = cardCountList;
            expect(data1).toEqual(cardData1);
            expect(data2).toEqual({ ...cardData2, count: 1 });
        });
    });
});
