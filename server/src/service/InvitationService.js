import { BaseService } from './BaseService';

export class InvitationService extends BaseService {
    static instance = null;

    static getInstance() {
        if (InvitationService.instance === null) {
            InvitationService.instance = new InvitationService();
        }

        return InvitationService.instance;
    }
}
