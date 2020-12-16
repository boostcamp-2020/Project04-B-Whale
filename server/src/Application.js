import 'reflect-metadata';
import 'express-async-errors';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import path from 'path';
import * as Sentry from '@sentry/node';
import * as Tracing from '@sentry/tracing';
import { validateOrReject } from 'class-validator';
import { createConnection, getConnection } from 'typeorm';
import {
    initializeTransactionalContext,
    patchTypeORMRepositoryWithBaseRepository,
} from 'typeorm-transactional-cls-hooked';
import passport from 'passport';
import { ConnectionOptionGenerator } from './common/config/database/ConnectionOptionGenerator';
import { DatabaseEnv } from './common/env/DatabaseEnv';
import { EnvType } from './common/env/EnvType';
import { IndexRouter } from './router';
import { errorHandler } from './common/middleware/errorHandler';
import { subscriber } from './common/middleware/subscriber';
import { NaverStrategy } from './common/config/passport/NaverStrategy';
import { GitHubStrategy } from './common/config/passport/GitHubStrategy';
import { JwtStrategy } from './common/config/passport/JwtStrategy';
import { shouldHandleError } from './common/middleware/shouldHandlerError';

export class Application {
    constructor() {
        this.httpServer = express();
    }

    listen(port) {
        return new Promise((resolve) => {
            this.httpServer.listen(port, () => {
                resolve();
            });
        });
    }

    async initialize() {
        this.initSentry();
        await this.initEnvironment();
        await this.initDatabase();
        this.initPassport();
        this.registerMiddleware();
    }

    async initEnvironment() {
        dotenv.config();
        if (!EnvType.contains(process.env.NODE_ENV)) {
            throw new Error(
                '잘못된 NODE_ENV 입니다. {production, development, local, test} 중 하나를 선택하십시오.',
            );
        }
        dotenv.config({
            path: path.join(`${process.cwd()}/.env.${process.env.NODE_ENV}`),
        });

        this.databaseEnv = new DatabaseEnv();
        await validateOrReject(this.databaseEnv);
    }

    async initDatabase() {
        initializeTransactionalContext();
        patchTypeORMRepositoryWithBaseRepository();
        this.connectionOptionGenerator = new ConnectionOptionGenerator(this.databaseEnv);
        await createConnection(this.connectionOptionGenerator.generateConnectionOption());
    }

    registerMiddleware() {
        if (process.env.SENTRY_DSN) {
            this.httpServer.use(Sentry.Handlers.requestHandler({ user: ['id', 'name'] }));
            this.httpServer.use(Sentry.Handlers.tracingHandler());
        }
        this.httpServer.use(cors());
        this.httpServer.use(express.json());
        this.httpServer.use(express.urlencoded({ extended: false }));
        this.httpServer.use(subscriber);
        this.httpServer.use(IndexRouter());
        if (process.env.SENTRY_DSN) {
            this.httpServer.use(
                Sentry.Handlers.errorHandler({
                    shouldHandleError,
                }),
            );
        }
        this.httpServer.use(errorHandler);
    }

    initPassport() {
        passport.use(new NaverStrategy());
        passport.use(new GitHubStrategy());
        passport.use(new JwtStrategy());
    }

    initSentry() {
        if (process.env.SENTRY_DSN) {
            Sentry.init({
                dsn: process.env.SENTRY_DSN,
                integrations: [
                    new Sentry.Integrations.Http({ tracing: true }),
                    new Tracing.Integrations.Express({ app: this.httpServer }),
                ],
                tracesSampleRate: 1.0,
            });
        }
    }

    async close() {
        await getConnection().close();
    }
}
