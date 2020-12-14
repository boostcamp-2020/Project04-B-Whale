import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { CardService } from '../../../src/service/CardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CardService.getAllCardCountByPeriod() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('정상적인 사용자가 카드를 조회할 때, 보드가 없으면 빈 배열 반환', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'user1',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            await em.save(user1);

            // when
            const cardService = CardService.getInstance();
            const cardCountList = await cardService.getAllCardCountByPeriod({
                startDate: '2020-07-01',
                endDate: '2020-07-31',
                userId: user1.id,
            });

            // then
            const data = cardCountList;
            expect(data).toEqual([]);
        });
    });

    test('정상적인 사용자가 startDate, endDate 기간동안의 모든 카드 조회', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
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
            const cardCountList = await cardService.getAllCardCountByPeriod({
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
});
