import moment from 'moment-timezone';
import { getCustomRepository } from 'typeorm';
import { getEntityManagerOrTransactionManager } from 'typeorm-transactional-cls-hooked';
import { Application } from '../../src/Application';
import { CustomCardRepository } from '../../src/dao/CustomCardRepository';
import { Board } from '../../src/model/Board';
import { Card } from '../../src/model/Card';
import { List } from '../../src/model/List';
import { User } from '../../src/model/User';
import { TransactionRollbackExecutor } from '../TransactionRollbackExecutor';
import { Comment } from '../../src/model/Comment';

describe('CustomCardRepository.findWithCommentsAndMembers() Test', () => {
    const app = new Application();

    beforeAll(async () => {
        await app.initialize();
    });

    afterAll(async (done) => {
        await app.close();
        done();
    });

    test('card0의 댓글을 조회했을 때 댓글을 오름차순으로 가져온다', async () => {
        const repo = getCustomRepository(CustomCardRepository);
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
                dueDate: moment().format(),
                list: list0,
                creator: user0,
            });
            await em.save(card0);

            const comment0 = em.create(Comment, {
                content: 'Comment content 0',
                user: user0,
                card: card0,
                createdAt: moment.tz('2020-01-01', 'Asia/Seoul').format(),
            });
            const comment1 = em.create(Comment, {
                content: 'Comment content 0',
                user: user0,
                card: card0,
                createdAt: moment.tz('2020-01-02', 'Asia/Seoul').format(),
            });
            const comment2 = em.create(Comment, {
                content: 'Comment content 0',
                user: user0,
                card: card0,
                createdAt: moment.tz('2020-01-03', 'Asia/Seoul').format(),
            });
            const comment3 = em.create(Comment, {
                content: 'Comment content 0',
                user: user0,
                card: card0,
                createdAt: moment.tz('2020-01-04', 'Asia/Seoul').format(),
            });
            const comment4 = em.create(Comment, {
                content: 'Comment content 0',
                user: user0,
                card: card0,
                createdAt: moment.tz('2020-01-05', 'Asia/Seoul').format(),
            });
            await em.save([comment0, comment1, comment2, comment3, comment4]);

            // when
            const card = await repo.findWithCommentsAndMembers(card0.id);

            // then
            const comments = card.comments.map((comment) => ({
                id: comment.id,
                createdAt: moment(comment.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD'),
            }));
            expect(card.comments).toHaveLength(5);
            expect(comments).toEqual([
                {
                    id: comment4.id,
                    createdAt: moment(comment4.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD'),
                },
                {
                    id: comment3.id,
                    createdAt: moment(comment3.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD'),
                },
                {
                    id: comment2.id,
                    createdAt: moment(comment2.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD'),
                },
                {
                    id: comment1.id,
                    createdAt: moment(comment1.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD'),
                },
                {
                    id: comment0.id,
                    createdAt: moment(comment0.createdAt).tz('Asia/Seoul').format('YYYY-MM-DD'),
                },
            ]);
        });
    });
});
