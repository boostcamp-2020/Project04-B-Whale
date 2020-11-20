import { AbstractService } from './AbstractService';

export class InvitationService extends AbstractService {
    static instance = null;

    static getInstance() {
        if (InvitationService.instance === null) {
            InvitationService.instance = new InvitationService();
        }

        return InvitationService.instance;
    }
}
