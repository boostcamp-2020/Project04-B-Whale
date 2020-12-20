import { ValidationError } from 'class-validator';
import { BusinessError } from '../error/BusinessError';

export const shouldHandleError = (error) => {
    switch (process.env.NODE_ENV) {
        case 'production':
            if (
                error instanceof BusinessError ||
                (Array.isArray(error) && error?.[0] instanceof ValidationError)
            ) {
                return false;
            }
            return true;
        case 'development':
            return true;
        default:
            return false;
    }
};
