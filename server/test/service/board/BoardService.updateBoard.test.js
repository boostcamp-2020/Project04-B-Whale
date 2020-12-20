import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { Board } from '../../../src/model/Board';
import { User } from '../../../src/model/User';
import { BoardService } from '../../../src/service/BoardService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('BoardService.updateBoard() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('보드 타이틀 수정 서비스 함수 정상 테스트', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user = { name: 'dhoon', socialId: '1234111', profileImageUrl: 'dh-image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            await userRepository.save([createUser]);

            const board = { title: 'board of dh', color: '#aa00ff', creator: createUser.id };
            const boardRepository = getRepository(Board);
            const createBoard = boardRepository.create(board);
            await boardRepository.save([createBoard]);

            // when
            const boardService = BoardService.getInstance();
            await boardService.updateBoard(createUser.id, createBoard.id, 'board of youngxpepp');
            const updatedBoard = await boardRepository.findOne(createBoard.id);

            // then
            expect(updatedBoard.title).toEqual('board of youngxpepp');
        });
    });
});
