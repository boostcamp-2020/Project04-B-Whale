import { EventSubscriber } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Comment } from '../model/Comment';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class CommentSubscriber {
    listenTo() {
        return Comment;
    }

    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(event.entity.creator);
        const namespace = getNamespace('localstorage');
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 ${namespace.get('cardTitle')} 카드에 댓글을 생성하였습니다. - ${
                event.entity.content
            }`,
        );
    }

    async afterRemove(event) {
        const namespace = getNamespace('localstorage');
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 댓글을 삭제하였습니다. - ${event.databaseEntity.content}`,
        );
    }
}
