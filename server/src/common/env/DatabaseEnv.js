import { IsBoolean, IsIn, IsNotEmpty, IsNumber, IsString, ValidateIf } from 'class-validator';
import { DatabaseType } from '../config/database/DatabaseType';

class DatabaseEnv {
    @IsNotEmpty()
    @IsIn(DatabaseType.values())
    databaseType;

    @ValidateIf((o) => o.databaseType === DatabaseType.MYSQL)
    @IsNotEmpty()
    databaseUrl;

    @IsNotEmpty()
    @IsBoolean()
    databaseDropSchema;

    @IsNotEmpty()
    @IsBoolean()
    databaseSynchronize;

    @ValidateIf((o) => o.databaseType === DatabaseType.MYSQL)
    @IsNotEmpty()
    @IsNumber()
    databaseConnectionLimit;

    databaseLogging;

    @ValidateIf((o) => o.databaseType === DatabaseType.SQLITE)
    @IsNotEmpty()
    @IsString()
    sqliteDatabase;

    constructor() {
        this.databaseType = process.env.DATABASE_TYPE;
        this.databaseUrl = process.env.DATABASE_URL ?? null;
        this.databaseConnectionLimit =
            process.env.DATABASE_CONNECTION_LIMIT === undefined
                ? 10
                : parseInt(process.env.DATABASE_CONNECTION_LIMIT, 10);
        this.databaseDropSchema =
            process.env.DATABASE_DROP_SCHEMA === undefined
                ? false
                : JSON.parse(process.env.DATABASE_DROP_SCHEMA.toLowerCase());
        this.databaseSynchronize =
            process.env.DATABASE_SYNCHRONIZE === undefined
                ? false
                : JSON.parse(process.env.DATABASE_SYNCHRONIZE.toLowerCase());
        this.databaseLogging =
            process.env.DATABASE_LOGGING === undefined ? ['error'] : this.splitDatabaseLogging();
        this.sqliteDatabase = process.env.SQLITE_DATABASE ?? ':memory:';
    }

    splitDatabaseLogging() {
        if (process.env.DATABASE_LOGGING === 'all') {
            return 'all';
        }

        return process.env.DATABASE_LOGGING.split(',');
    }

    getDatabaseType() {
        return this.databaseType;
    }

    getDatabaseUrl() {
        return this.databaseUrl;
    }

    getDatabaseDropSchema() {
        return this.databaseDropSchema;
    }

    getDatabaseSynchronize() {
        return this.databaseSynchronize;
    }

    getDatabaseConnectionLimit() {
        return this.databaseConnectionLimit;
    }

    getDatabaseLogging() {
        return this.databaseLogging;
    }

    getSqliteDatabase() {
        return this.sqliteDatabase;
    }
}

export { DatabaseEnv };
