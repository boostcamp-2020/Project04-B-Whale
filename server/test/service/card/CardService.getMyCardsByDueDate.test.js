import moment from 'moment';
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

describe('CardService.getMyCardsByDueDate() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('user0이 생성한 카드와 멤버로 할당된 카드 중 dueDate가 2020-12-03인 카드 목록 조회', async () => {
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

    test('user0이 생성한 카드와 멤버로 할당된 카드가 없을 때 빈 배열 반환', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
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

    test('user0이 생성한 카드와 멤버로 할당된 카드가 없을 때 빈 배열 반환', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
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
});
