import { BaseService } from './BaseService';

export class CardService extends BaseService {
    static instance = null;

    static getInstance() {
        if (CardService.instance === null) {
            CardService.instance = new CardService();
        }

        return CardService.instance;
    }
}
