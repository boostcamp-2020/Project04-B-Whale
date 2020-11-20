import path from 'path';
import { DatabaseType } from './DatabaseType';

class ConnectionOptionGenerator {
    static SQLITE_DATABASE = ':memory:';

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
            extra: {},
        };

        switch (this.databaseEnv.getDatabaseType()) {
            case DatabaseType.MYSQL:
                connectionOption.url = this.databaseEnv.getDatabaseUrl();
                connectionOption.connectTimeout = 3000;
                connectionOption.acquireTimeout = 5000;
                connectionOption.extra.connectionLimit = this.databaseEnv.getDatabaseConnectionLimit();
                break;
            case DatabaseType.SQLITE:
                connectionOption.database = ConnectionOptionGenerator.SQLITE_DATABASE;
                break;
            default:
        }

        return connectionOption;
    }
}

export { ConnectionOptionGenerator };
