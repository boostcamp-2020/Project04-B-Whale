import { AbstractService } from './AbstractService';

export class BoardService extends AbstractService {
    static instance = null;

    static getInstance() {
        if (BoardService.instance === null) {
            BoardService.instance = new BoardService();
        }

        return BoardService.instance;
    }
}
