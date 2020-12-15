import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../../src/Application';
import { User } from '../../../src/model/User';
import { UserService } from '../../../src/service/UserService';
import { TransactionRollbackExecutor } from '../../TransactionRollbackExecutor';

describe('UserService.getUserStartsWithName() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initialize();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('userName으로 시작하는 유저들 조회', async () => {
        const userService = UserService.getInstance();
        await TransactionRollbackExecutor.rollback(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user1 = em.create(User, {
                name: 'whale-dhoon',
                socialId: 'naver1',
                profileImageUrl: 'image',
            });
            await em.save(user1);

            const user2 = em.create(User, {
                name: 'whale-geonhonglee',
                socialId: 'naver1',
                profileImageUrl: 'image',
            });
            await em.save(user2);

            const user3 = em.create(User, {
                name: 'whale-sooyeon',
                socialId: 'naver3',
                profileImageUrl: 'image',
            });
            await em.save(user3);

            // when
            const users = await userService.getUserStartsWithName('whale');

            // then
            expect(users).toEqual([
                { id: user1.id, name: 'whale-dhoon', profileImageUrl: 'image' },
                { id: user2.id, name: 'whale-geonhonglee', profileImageUrl: 'image' },
                { id: user3.id, name: 'whale-sooyeon', profileImageUrl: 'image' },
            ]);
        });
    });
});
