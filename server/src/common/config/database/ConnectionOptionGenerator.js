import path from 'path';
import { DatabaseType } from './DatabaseType';

class ConnectionOptionGenerator {
    constructor(databaseEnv) {
        this.databaseEnv = databaseEnv;
    }

    generateConnectionOption() {
        const connectionOption = {
            type: this.databaseEnv.getDatabaseType(),
            entities: [path.resolve(`${__dirname}/../../../model/*.js`)],
            logging: this.databaseEnv.getDatabaseLogging(),
            dropSchema: this.databaseEnv.getDatabaseDropSchema(),
            synchronize: this.databaseEnv.getDatabaseSynchronize(),
            subscribers: [path.resolve(`${__dirname}/../../../subscriber/*.js`)],
            extra: {},
        };

        switch (this.databaseEnv.getDatabaseType()) {
            case DatabaseType.MYSQL:
                connectionOption.url = this.databaseEnv.getDatabaseUrl();
                connectionOption.connectTimeout = 3000;
                // connectionOption.acquireTimeout = 5000;
                connectionOption.bigNumberStrings = false;
                connectionOption.extra.connectionLimit = this.databaseEnv.getDatabaseConnectionLimit();
                break;
            case DatabaseType.SQLITE:
                connectionOption.database = this.databaseEnv.getSqliteDatabase();
                break;
            default:
        }

        return connectionOption;
    }
}

export { ConnectionOptionGenerator };
