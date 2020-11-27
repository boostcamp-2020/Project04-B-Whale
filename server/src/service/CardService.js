import { AbstractService } from './AbstractService';

export class CardService extends AbstractService {
    static instance = null;

    static getInstance() {
        if (CardService.instance === null) {
            CardService.instance = new CardService();
        }

        return CardService.instance;
    }
}
