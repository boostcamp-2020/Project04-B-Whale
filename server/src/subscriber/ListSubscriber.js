import { EventSubscriber } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Transactional } from 'typeorm-transactional-cls-hooked';
import { List } from '../model/List';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class ListSubscriber {
    listenTo() {
        return List;
    }

    @Transactional()
    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const userId = !event.entity.creator?.id ? event.entity.creator : event.entity.creator?.id;
        const user = await userService.getUserById(userId);
        const boardId = !+event.entity.board ? event.entity.board?.id : +event.entity.board;
        await activityService.createActivity(
            boardId,
            `${user.name}님이 리스트 ${event.entity.title}을 생성하였습니다.`,
        );
    }

    @Transactional()
    async afterUpdate(event) {
        const namespace = getNamespace('localstorage');
        if (!namespace?.get('userId')) return;

        if (event.entity.position !== event.databaseEntity.position) return;
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(namespace.get('userId'));
        const boardId = !+event.entity.board ? event.entity.board?.id : +event.entity.board;
        await activityService.createActivity(
            boardId,
            `${user.name}님이 리스트 타이틀을 변경하였습니다.(${event.databaseEntity.title} -> ${event.entity.title})`,
        );
    }

    @Transactional()
    async afterRemove(event) {
        const namespace = getNamespace('localstorage');
        if (!namespace?.get('userId')) return;

        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 리스트 ${event.databaseEntity.title}을 삭제하였습니다.`,
        );
    }
}
