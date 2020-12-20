import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
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

    test('보드삭제 api 서비스 함수 deleteBoard 테스트', async () => {
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

            // when
            const boardService = BoardService.getInstance();
            await boardService.deleteBoard({ userId: user.id, boardId: board.id });
            const deleteBoard = await em.findOne(Board, { id: board.id });

            // then
            expect(deleteBoard).toEqual(undefined);
        });
    });
});
