import { EventSubscriber } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Transactional } from 'typeorm-transactional-cls-hooked';
import { Board } from '../model/Board';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class BoardSubscriber {
    listenTo() {
        return Board;
    }

    @Transactional()
    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const userId = !event.entity.creator?.id ? event.entity.creator : event.entity.creator?.id;

        const user = await userService.getUserById(userId);

        await activityService.createActivity(
            event.entity.id,
            `${user.name}님이 ${event.entity.title} 보드를 생성하였습니다.`,
        );
    }

    @Transactional()
    async afterUpdate(event) {
        const namespace = getNamespace('localstorage');
        if (!namespace?.get('userId')) return;

        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            event.entity.id,
            `${user.name}님이 보드 타이틀을 변경하였습니다.(${event.databaseEntity.title} -> ${event.entity.title})`,
        );
    }
}
