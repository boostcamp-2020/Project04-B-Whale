import { EventSubscriber, getRepository } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { List } from '../model/List';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class ListSubscriber {
    listenTo() {
        return List;
    }

    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(event.entity.creator);

        await activityService.createActivity(
            +event.entity.board,
            `${user.name}님이 리스트 ${event.entity.title}을 생성하였습니다.`,
        );
    }

    async afterUpdate(event) {
        if (event.entity.position !== event.databaseEntity.position) return;
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const namespace = getNamespace('localstorage');
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            event.entity.board.id,
            `${user.name}님이 리스트 타이틀을 변경하였습니다.(${event.databaseEntity.title} -> ${event.entity.title})`,
        );
    }

    async afterRemove(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const namespace = getNamespace('localstorage');
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 리스트 ${event.databaseEntity.title}을 삭제하였습니다.`,
        );
    }
}
