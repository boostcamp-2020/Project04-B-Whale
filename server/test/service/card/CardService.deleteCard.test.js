import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { CardService } from '../../../src/service/CardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('CardService.deleteCard() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('카드 삭제 api 서비스 함수 deleteCard 테스트', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user = em.create(User, {
                name: 'dhoon',
                socialId: '1234',
                profileImageUrl: 'image',
            });
            await em.save(user);

            const board = em.create(Board, {
                title: 'board of dh',
                color: '#aa00ff',
                creator: user.id,
            });
            await em.save(board);

            const list = em.create(List, {
                title: 'dh-list',
                position: 1,
                board: board.id,
                creator: user.id,
            });
            await em.save(list);

            const card = em.create(Card, {
                title: 'dh-list',
                position: 1,
                list: list.id,
                creator: user.id,
                content: 'list-detail',
                dueDate: '2020-12-31 00:00:00',
            });
            await em.save(card);

            // when
            const cardService = CardService.getInstance();
            await cardService.deleteCard({ userId: user.id, cardId: card.id });
            const deleteCard = await em.findOne(Card, { id: card.id });

            // then
            expect(deleteCard).toEqual(undefined);
        });
    });
});
