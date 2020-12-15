import request from 'supertest';
import { getRepository } from 'typeorm';
import { Application } from '../../../src/Application';
import { JwtUtil } from '../../../src/common/util/JwtUtil';
import { User } from '../../../src/model/User';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('POST /api/board', () => {
    const app = new Application();
    let jwtUtil = null;

    beforeAll(async () => {
        await app.initialize();
        jwtUtil = JwtUtil.getInstance();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('POST /api/board를 호출할 때, 요청 바디가 올바르지 않으면 400을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            // when
            const response = await request(app.httpServer).post('/api/board').send({ title: null });

            // then
            expect(response.status).toEqual(400);
        });
    });

    test('POST /api/board를 호출할 때, 권한이 없으면 401을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const token = 'Bearer fakeToken';

            // when
            const response = await request(app.httpServer).post('/api/board').set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(401);
        });
    });

    test('POST /api/board가 정상적으로 호출되었을 때, 201을 리턴한다.', async () => {
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const user = { name: 'user', socialId: '1234', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);

            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });

            // when
            const response = await request(app.httpServer)
                .post('/api/board')
                .set({
                    Authorization: token,
                    'Content-Type': 'application/json',
                })
                .send({ title: 'test title', color: '#000000', creator: createdUser.id });

            // then
            expect(response.status).toEqual(201);
        });
    });
});
