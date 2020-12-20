import { getCustomRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { CustomBoardRepository } from '../../src/dao/CustomBoardRepository';
import { Board } from '../../src/model/Board';
import { Invitation } from '../../src/model/Invitation';
import { User } from '../../src/model/User';
import { TransactionRollbackExecutor } from '../TransactionRollbackExecutor';

describe('CustomBoardRepository', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initialize();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('findByCreatorId(): user0이 만든 board 조회', async () => {
        const repo = getCustomRepository(CustomBoardRepository);
        await TransactionRollbackExecutor.rollback(async () => {
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

            // when
            const boards = await repo.findByCreatorId(user0.id);

            // then
            expect(boards?.[0].id).toEqual(board0.id);
        });
    });

    test('findInvitedBoardsByUserId(): user0의 초대된 board 조회', async () => {
        const repo = getCustomRepository(CustomBoardRepository);
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
                name: 'dhoon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);
            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user1,
            });
            const board1 = em.create(Board, {
                title: 'board title 1',
                color: '#FFFFFF',
                creator: user1,
            });
            const board2 = em.create(Board, {
                title: 'board title 2',
                color: '#FFFFFF',
                creator: user1,
            });
            await em.save([board0, board1, board2]);
            await em.save([
                em.create(Invitation, {
                    user: user0,
                    board: board0,
                }),
                em.create(Invitation, {
                    user: user0,
                    board: board1,
                }),
                em.create(Invitation, {
                    user: user0,
                    board: board2,
                }),
            ]);

            // when
            const boards = await repo.findInvitedBoardsByUserId(user0.id);

            // then
            expect(boards).toHaveLength(3);
            expect(boards.map((board) => board.id)).toContain(board0.id, board1.id, board2.id);
        });
    });
});
