import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { Card } from '../../../src/model/Card';
import { Invitation } from '../../../src/model/Invitation';
import { List } from '../../../src/model/List';
import { User } from '../../../src/model/User';
import { BoardService } from '../../../src/service/BoardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('BoardService.deleteBoard() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('보드에서 나가기 api 서비스 함수  테스트', async () => {
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

            const invitation = em.create(Invitation, {
                user: user.id,
                board: board.id,
            });
            await em.save(invitation);

            // when
            const boardService = BoardService.getInstance();
            await boardService.exitBoard(user.id, board.id);
            const deleteInvitation = await em.findOne(Invitation, {
                user: user.id,
                board: board.id,
            });

            // then
            expect(deleteInvitation).toEqual(undefined);
        });
    });
});
