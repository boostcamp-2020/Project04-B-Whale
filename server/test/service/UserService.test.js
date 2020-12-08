import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { EntityNotFoundError } from '../../src/common/error/EntityNotFoundError';
import { User } from '../../src/model/User';
import { UserService } from '../../src/service/UserService';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

describe('UserService Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initialize();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('UserService.getUserById(): user0을 조회했을 때 user0 반환', async () => {
        const userService = UserService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');
            const user0 = em.create(User, {
                socialId: '1234567890',
                name: 'geonhonglee',
                profileImageUrl: '',
            });
            await em.save(user0);

            // when
            const _user0 = await userService.getUserById(user0.id);

            // then
            expect(_user0.id).toEqual(user0.id);
        });
    });

    test('UserService.getUserById(): 없는 사용자 조회했을 때 EntityNotFoundError 발생', async () => {
        const userService = UserService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            try {
                await userService.getUserById(0);
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(EntityNotFoundError);
            }
        });
    });

    test('UserService.getUserStartsWithName(userName): userName으로 시작하는 유저들 조회', async () => {
        const userService = UserService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
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
