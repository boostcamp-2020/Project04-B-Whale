import { EventSubscriber } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Transactional } from 'typeorm-transactional-cls-hooked';
import { Invitation } from '../model/Invitation';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class InvitationSubscriber {
    listenTo() {
        return Invitation;
    }

    @Transactional()
    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();

        const namespace = getNamespace('localstorage');
        if (!namespace?.get('userId')) return;

        const user = await userService.getUserById(namespace.get('userId'));
        const invitedUser = await userService.getUserById(event.entity.user);

        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 현재보드에 ${invitedUser.name}님을 초대하였습니다.`,
        );
    }
}
