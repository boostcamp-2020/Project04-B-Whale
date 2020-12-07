import request, { agent } from 'supertest';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { getRepository } from 'typeorm';
import { Application } from '../../src/Application';
import { JwtUtil } from '../../src/common/util/JwtUtil';
import { User } from '../../src/model/User';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

describe('UserRouter Test', () => {
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

    test('GET /api/user/me: user0을 조회했을 때 user0 반환 상태 코드 200', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user0 = em.create(User, {
                socialId: '1234567890',
                name: 'geonhonglee',
                profileImageUrl: '',
            });
            await em.save(user0);

            const accessToken = await jwtUtil.generateAccessToken({
                userId: user0.id,
            });

            // when
            const response = await agent(app.httpServer)
                .get('/api/user/me')
                .set('Authorization', accessToken)
                .send();

            // then
            expect(response.status).toEqual(200);
            expect(response.body).toEqual({
                id: user0.id,
                name: user0.name,
                profileImageUrl: user0.profileImageUrl,
            });
        });
    });

    test('GET /api/user?username= 유저 검색 라우터 정상호출 시 상태코드 200 반환', async () => {
        await TestTransactionDelegate.transaction(async () => {
            // given
            const user = { name: 'dhoon', socialId: 'naver', profileImageUrl: 'image' };
            const userRepository = getRepository(User);
            const createUser = userRepository.create(user);
            const createdUser = await userRepository.save(createUser);
            const token = await jwtUtil.generateAccessToken({
                userId: createdUser.id,
                username: createdUser.name,
            });

            // when
            const response = await request(app.httpServer).get('/api/user?username=dhoon').set({
                Authorization: token,
                'Content-Type': 'application/json',
            });

            // then
            expect(response.status).toEqual(200);
        });
    });
});
