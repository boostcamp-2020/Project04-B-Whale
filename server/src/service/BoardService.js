import { BaseService } from './BaseService';

export class BoardService extends BaseService {
    static instance = null;

    static getInstance() {
        if (BoardService.instance === null) {
            BoardService.instance = new BoardService();
        }

        return BoardService.instance;
    }
}
