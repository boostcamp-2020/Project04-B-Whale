import moment from 'moment';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { CardService } from '../../../src/service/CardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CardService.modifyCardById() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('일부 데이터만 변경', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            await em.save(user1);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

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
                list: list1.id,
                creator: user1.id,
            });
            await em.save(card1);

            const updateData = {
                listId: undefined,
                title: 'card update title',
                content: undefined,
                position: undefined,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            await cardService.modifyCardById({
                userId: user1.id,
                cardId: card1.id,
                listId: updateData.listId,
                title: updateData.title,
                content: updateData.content,
                position: updateData.position,
                dueDate: updateData.dueDate,
            });

            const updatedCard = await em.findOne(Card, card1.id, { relations: ['list'] });

            // then
            expect(updatedCard.list.id).toEqual(card1.list);
            expect(updatedCard.title).toEqual(updateData.title);
            expect(updatedCard.content).toEqual(card1.content);
            expect(updatedCard.position).toEqual(card1.position);
            expect(moment(updatedCard.dueDate).tz('Asia/Seoul').format()).toEqual(
                moment(updateData.dueDate).tz('Asia/Seoul').format(),
            );
        });
    });

    test('전체 데이터 변경', async () => {
        const cardService = CardService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user1 = em.create(User, {
                socialId: '1',
                name: 'user1',
                profileImageUrl: 'image1',
            });
            await em.save(user1);

            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FF0000',
                creator: user1,
            });
            await em.save(board1);

            const list1 = em.create(List, {
                title: 'list title 1',
                position: 1,
                board: board1,
                creator: user1,
            });
            const list2 = em.create(List, {
                title: 'list title 2',
                position: 1,
                board: board1,
                creator: user1,
            });
            await em.save([list1, list2]);

            const card1 = em.create(Card, {
                title: 'card title 1',
                content: 'card content 1',
                position: 1,
                dueDate: moment('2020-12-03T13:40:00').format(),
                list: list1,
                creator: user1,
            });
            await em.save(card1);

            const updateData = {
                listId: list2.id,
                title: 'card update title',
                content: 'card update content',
                position: 2,
                dueDate: moment('2020-12-30T13:40:00').format(),
            };

            // when
            await cardService.modifyCardById({
                userId: user1.id,
                cardId: card1.id,
                listId: updateData.listId,
                title: updateData.title,
                content: updateData.content,
                position: updateData.position,
                dueDate: updateData.dueDate,
            });

            const updatedCard = await em.findOne(Card, card1.id, { relations: ['list'] });

            // then
            expect(updatedCard.list.id).toEqual(updateData.listId);
            expect(updatedCard.title).toEqual(updateData.title);
            expect(updatedCard.content).toEqual(updateData.content);
            expect(updatedCard.position).toEqual(updateData.position);
            expect(moment(updatedCard.dueDate).tz('Asia/Seoul').format()).toEqual(
                moment(updateData.dueDate).tz('Asia/Seoul').format(),
            );
        });
    });
});
