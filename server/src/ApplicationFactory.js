import { Application } from './Application';

export class ApplicationFactory {
    static async create() {
        const application = new Application();
        await application.initialize();
        return application;
    }
}
