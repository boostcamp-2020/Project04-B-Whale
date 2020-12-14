import moment from 'moment-timezone';
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

describe('CardService.addMemberToCardByUserIds() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('카드에 member 여러명 추가', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            const user2 = em.create(User, {
                socialId: '2',
                name: 'user2',
                profileImageUrl: 'image2',
            });
            const user3 = em.create(User, {
                socialId: '3',
                name: 'user3',
                profileImageUrl: 'image3',
            });
            await em.save([user1, user2, user3]);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            const invitation1 = em.create(Invitation, { user: user2, board: board1 });
            const invitation2 = em.create(Invitation, { user: user3, board: board1 });
            await em.save([invitation1, invitation2]);

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            // when
            const userIds = [user1.id, user2.id, user3.id];
            await cardService.addMemberToCardByUserIds({
                cardId: card1.id,
                userId: user1.id,
                userIds,
            });

            // then
            const members = await em.find(Member, {
                relations: ['card', 'user'],
                where: { card: card1.id },
            });

            expect(members).toHaveLength(3);
            expect(members[0].user.id).toEqual(user1.id);
            expect(members[0].card.id).toEqual(card1.id);
            expect(members[1].user.id).toEqual(user2.id);
            expect(members[1].card.id).toEqual(card1.id);
            expect(members[2].user.id).toEqual(user3.id);
            expect(members[2].card.id).toEqual(card1.id);
        });
    });

    test('카드에 member 추가 및 삭제', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            const user2 = em.create(User, {
                socialId: '2',
                name: 'user2',
                profileImageUrl: 'image2',
            });
            const user3 = em.create(User, {
                socialId: '3',
                name: 'user3',
                profileImageUrl: 'image3',
            });
            await em.save([user1, user2, user3]);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            const invitation1 = em.create(Invitation, { user: user2, board: board1 });
            const invitation2 = em.create(Invitation, { user: user3, board: board1 });
            await em.save([invitation1, invitation2]);

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            await em.save([
                em.create(Member, { user: user1, card: card1 }),
                em.create(Member, { user: user2, card: card1 }),
            ]);

            // when
            const userIds = [user2.id, user3.id];
            await cardService.addMemberToCardByUserIds({
                cardId: card1.id,
                userId: user1.id,
                userIds,
            });

            // then
            const members = await em.find(Member, {
                relations: ['card', 'user'],
                where: { card: card1.id },
            });

            expect(members).toHaveLength(2);
            expect(members[0].user.id).toEqual(user2.id);
            expect(members[0].card.id).toEqual(card1.id);
            expect(members[1].user.id).toEqual(user3.id);
            expect(members[1].card.id).toEqual(card1.id);
        });
    });

    test('카드에 모든 member 삭제', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            const user2 = em.create(User, {
                socialId: '2',
                name: 'user2',
                profileImageUrl: 'image2',
            });
            const user3 = em.create(User, {
                socialId: '3',
                name: 'user3',
                profileImageUrl: 'image3',
            });
            await em.save([user1, user2, user3]);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            const invitation1 = em.create(Invitation, { user: user2, board: board1 });
            const invitation2 = em.create(Invitation, { user: user3, board: board1 });
            await em.save([invitation1, invitation2]);

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save(list1);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            await em.save([
                em.create(Member, { user: user1, card: card1 }),
                em.create(Member, { user: user2, card: card1 }),
                em.create(Member, { user: user3, card: card1 }),
            ]);

            // when
            const userIds = [];
            await cardService.addMemberToCardByUserIds({
                cardId: card1.id,
                userId: user1.id,
                userIds,
            });

            // then
            const members = await em.find(Member, {
                relations: ['card', 'user'],
                where: { card: card1.id },
            });

            expect(members).toHaveLength(0);
        });
    });
});
