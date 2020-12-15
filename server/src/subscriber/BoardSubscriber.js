import { EventSubscriber, getRepository } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Board } from '../model/Board';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class BoardSubscriber {
    listenTo() {
        return Board;
    }

    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(event.entity.creator);
        await activityService.createActivity(
            +event.entity.id,
            `${user.name}님이 보드 ${event.entity.title}을 생성하였습니다.`,
        );
    }

    async afterUpdate(event) {
        if (event.entity.position) return;
        const boardNamespace = getNamespace('Board');
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(boardNamespace.userId);
        await activityService.createActivity(
            event.entity.id,
            `${user.name}님이 보드 타이틀을 변경하였습니다.(${event.databaseEntity.title} -> ${event.entity.title})`,
        );
    }

    async afterRemove(event) {
        const boardNamespace = getNamespace('Board');
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(boardNamespace.userId);
        await activityService.createActivity(
            event.databaseEntity.id,
            `${user.name}님이 보드 ${event.databaseEntity.title}을 삭제하였습니다.`,
        );
    }
}
