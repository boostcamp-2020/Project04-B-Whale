import { EventSubscriber } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Transactional } from 'typeorm-transactional-cls-hooked';
import { Comment } from '../model/Comment';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class CommentSubscriber {
    listenTo() {
        return Comment;
    }

    @Transactional()
    async afterInsert(event) {
        const namespace = getNamespace('localstorage');
        if (!namespace?.get('boardId')) return;

        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(event.entity.user.id);
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 ${namespace.get('cardTitle')} 카드에 댓글을 생성하였습니다. - ${
                event.entity.content
            }`,
        );
    }

    @Transactional()
    async afterRemove(event) {
        const namespace = getNamespace('localstorage');
        if (!namespace?.get('boardId')) return;

        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 댓글을 삭제하였습니다. - ${event.databaseEntity.content}`,
        );
    }
}
