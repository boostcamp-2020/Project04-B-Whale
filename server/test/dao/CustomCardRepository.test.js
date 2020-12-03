import moment from 'moment';
import { getCustomRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { CustomCardRepository } from '../../src/dao/CustomCardRepository';
import { Board } from '../../src/model/Board';
import { Card } from '../../src/model/Card';
import { Invitation } from '../../src/model/Invitation';
import { List } from '../../src/model/List';
import { Member } from '../../src/model/Member';
import { User } from '../../src/model/User';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

describe('CustomCardRepository', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initialize();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('findByDueDateAndCreatorId(): dueDate가 2020년 1월 1일인 카드 조회', async () => {
        const repo = getCustomRepository(CustomCardRepository);
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

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
                dueDate: moment().format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 10,
                dueDate: moment('2020-01-01T13:00:00').format(),
                list: list0,
                creator: user0,
            });
            const card2 = em.create(Card, {
                title: 'card title 2',
                content: 'card content 2',
                position: 20,
                dueDate: moment('2020-01-01T23:59:59').format(),
                list: list0,
                creator: user0,
            });
            await em.save([card0, card1, card2]);

            // when
            const cards = await repo.findByDueDateAndCreatorId({
                dueDate: moment('2020-01-01').format('YYYY-MM-DD'),
                creatorId: user0.id,
            });

            // then
            expect(cards.map((card) => card.id)).toContain(card1.id, card2.id);
        });
    });

    test('findByDueDateAndMemberUserId(): dueDate가 2020년 1월 1일이고, user1에게 할당된 카드 조회', async () => {
        const repo = getCustomRepository(CustomCardRepository);
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
            await em.save(board0);

            await em.save(
                em.create(Invitation, {
                    user: user1,
                    board: board0,
                }),
            );

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
                dueDate: moment().format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 10,
                dueDate: moment('2020-01-01T13:00:00').format(),
                list: list0,
                creator: user0,
            });
            const card2 = em.create(Card, {
                title: 'card title 2',
                content: 'card content 2',
                position: 20,
                dueDate: moment('2020-01-01T23:59:59').format(),
                list: list0,
                creator: user0,
            });
            await em.save([card0, card1, card2]);

            await em.save([
                em.create(Member, { user: user1, card: card0 }),
                em.create(Member, { user: user1, card: card1 }),
            ]);

            // when

            const cards = await repo.findByDueDateAndMemberUserId({
                dueDate: moment('2020-01-01').format('YYYY-MM-DD'),
                userId: user1.id,
            });

            // then
            expect(cards?.[0]?.id).toEqual(card1.id);
        });
    });

    test('findByDueDateAndBoardIds(): board0과 board1에 있는 카드 중 dueDate가 2020년 1월 1일인 카드 조회', async () => {
        const repo = getCustomRepository(CustomCardRepository);
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
            await em.save([board0, board1]);

            await em.save(
                em.create(Invitation, {
                    user: user1,
                    board: board0,
                }),
                em.create(Invitation, {
                    user: user0,
                    board: board1,
                }),
            );

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
            await em.save([list0, list1]);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment().format(),
                list: list0,
                creator: user0,
            });
            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 10,
                dueDate: moment('2020-01-01T13:00:00').format(),
                list: list0,
                creator: user0,
            });
            const card2 = em.create(Card, {
                title: 'card title ',
                content: 'card content 2',
                position: 0,
                dueDate: moment('2020-01-01T23:59:59').format(),
                list: list1,
                creator: user1,
            });
            const card3 = em.create(Card, {
                title: 'card title 3',
                content: 'card content 3',
                position: 10,
                dueDate: moment('2020-01-01T23:59:59').format(),
                list: list1,
                creator: user1,
            });
            await em.save([card0, card1, card2, card3]);

            // when
            const cards = await repo.findByDueDateAndBoardIds({
                dueDate: '2020-01-01',
                boardIds: [board0.id, board1.id],
            });

            // then
            expect(cards?.[0]?.id).toEqual(card1.id);
        });
    });
});
