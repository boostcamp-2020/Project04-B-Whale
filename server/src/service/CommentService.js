import { BaseService } from './BaseService';

export class CommentService extends BaseService {
    static instance = null;

    static getInstance() {
        if (CommentService.instance === null) {
            CommentService.instance = new CommentService();
        }

        return CommentService.instance;
    }
}
