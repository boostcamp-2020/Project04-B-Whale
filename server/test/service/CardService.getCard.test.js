import moment from 'moment';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { EntityNotFoundError } from '../../src/common/error/EntityNotFoundError';
import { ForbiddenError } from '../../src/common/error/ForbiddenError';
import { Board } from '../../src/model/Board';
import { Card } from '../../src/model/Card';
import { Comment } from '../../src/model/Comment';
import { Invitation } from '../../src/model/Invitation';
import { List } from '../../src/model/List';
import { Member } from '../../src/model/Member';
import { User } from '../../src/model/User';
import { CardService } from '../../src/service/CardService';
import { TestTransactionDelegate } from '../TestTransactionDelegate';

describe('CardService.getCard() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initEnvironment();
        await app.initDatabase();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('존재하지 않는 카드 id로 getCard 호출 시 EntityNotFoundError 발생', async () => {
        const cardService = CardService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: 0,
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            await em.save(user0);

            // when
            // then
            try {
                await cardService.getCard({ userId: user0.id, cardId: 1 });
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(EntityNotFoundError);
            }
        });
    });

    test('초대되지 않은 보드의 카드를 조회했을 때 ForbiddenError 발생', async () => {
        const cardService = CardService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'park-sooyeon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            await em.save(list0);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment.tz('2020-12-03T09:37:00', 'Asia/Seoul').format(),
                list: list0,
                creator: user0,
            });
            await em.save(card0);

            // when
            // then
            try {
                await cardService.getCard({ userId: user1.id, cardId: card0.id });
                fail();
            } catch (error) {
                expect(error).toBeInstanceOf(ForbiddenError);
            }
        });
    });

    test('user0이 만든 본인이 만든 card0 조회', async () => {
        const cardService = CardService.getInstance();
        await TestTransactionDelegate.transaction(async () => {
            // given
            const em = getEntityManagerOrTransactionManager('default');

            const user0 = em.create(User, {
                socialId: '0',
                name: 'youngxpepp',
                profileImageUrl: 'http://',
            });
            const user1 = em.create(User, {
                socialId: '1',
                name: 'park-sooyeon',
                profileImageUrl: 'http://',
            });
            await em.save([user0, user1]);

            const board0 = em.create(Board, {
                title: 'board title 0',
                color: '#FFFFFF',
                creator: user0,
            });
            await em.save(board0);

            const list0 = em.create(List, {
                title: 'list title 0',
                position: 0,
                board: board0,
                creator: user0,
            });
            await em.save(list0);

            const card0 = em.create(Card, {
                title: 'card title 0',
                content: 'card content 0',
                position: 0,
                dueDate: moment.tz('2020-12-03T09:37:00', 'Asia/Seoul').format(),
                list: list0,
                creator: user0,
            });
            await em.save(card0);

            await em.save(em.create(Invitation, { user: user1, board: board0 }));
            await em.save(
                em.create(Member, {
                    user: user1,
                    card: card0,
                }),
            );

            const comment0 = em.create(Comment, {
                content: 'hey~',
                user: user1,
                card: card0,
            });
            await em.save(comment0);

            // when
            const card = await cardService.getCard({ userId: user0.id, cardId: card0.id });

            // then
            expect(card).toEqual({
                id: card0.id,
                title: card0.title,
                content: card0.content,
                dueDate: card0.dueDate,
                list: {
                    id: list0.id,
                    title: list0.title,
                },
                board: {
                    id: board0.id,
                    title: board0.title,
                },
                members: expect.any(Array),
                comments: expect.any(Array),
            });
            expect(card.members).toHaveLength(1);
            expect(card.members?.[0]).toEqual({
                id: user1.id,
                name: user1.name,
                profileImageUrl: user1.profileImageUrl,
            });
            expect(card.comments).toHaveLength(1);
            expect(card.comments?.[0]).toEqual({
                id: comment0.id,
                content: comment0.content,
                createdAt: moment(comment0.createdAt).tz('Asia/Seoul').format(),
                user: {
                    id: user1.id,
                    name: user1.name,
                    profileImageUrl: user1.profileImageUrl,
                },
            });
        });
    });
});
