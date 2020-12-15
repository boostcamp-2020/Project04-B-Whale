import moment from 'moment';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { CardService } from '../../../src/service/CardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CardService.getAllCardsByDueDate() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('user0이 생성한 보드와 초대된 보드의 카드 중 dueDate가 2020-12-03인 카드 조회', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
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
