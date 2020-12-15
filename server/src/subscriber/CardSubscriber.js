import { EventSubscriber, getRepository } from 'typeorm';
import { getNamespace } from 'cls-hooked';
import { Card } from '../model/Card';
import { List } from '../model/List';
import { ActivityService } from '../service/ActivityService';
import { UserService } from '../service/UserService';

@EventSubscriber()
export class CardSubscriber {
    listenTo() {
        return Card;
    }

    async afterInsert(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const user = await userService.getUserById(event.entity.creator);

        const namespace = getNamespace('localstorage');
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 카드 ${event.entity.title}을 ${namespace.get(
                'listTitle',
            )} 리스트에 생성하였습니다.`,
        );
    }

    async afterUpdate(event) {
        if (!event.entity.list || event.entity.list === event.databaseEntity.list.id) return;
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();

        const listRepository = getRepository(List);
        const prevList = await listRepository.findOne(event.databaseEntity.list, {
            loadRelationIds: {
                relations: ['board'],
                disableMixedMap: true,
            },
        });
        const currentList = await listRepository.findOne(event.entity.list, {
            loadRelationIds: {
                relations: ['board'],
                disableMixedMap: true,
            },
        });
        const namespace = getNamespace('localstorage');
        const user = await userService.getUserById(namespace.get('userId'));

        await activityService.createActivity(
            currentList.board.id,
            `${user.name}님이 카드 ${event.entity.title}을 ${prevList.title} 리스트에서 ${currentList.title} 리스트로 이동하였습니다.`,
        );
    }

    async afterRemove(event) {
        const activityService = ActivityService.getInstance();
        const userService = UserService.getInstance();
        const namespace = getNamespace('localstorage');
        const user = await userService.getUserById(namespace.get('userId'));
        await activityService.createActivity(
            namespace.get('boardId'),
            `${user.name}님이 카드 ${event.databaseEntity.title}을 삭제하였습니다.`,
        );
    }
}
