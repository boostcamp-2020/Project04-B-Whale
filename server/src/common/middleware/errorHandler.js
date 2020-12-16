import { ValidationError } from 'class-validator';
import { BusinessError } from '../error/BusinessError';
import { ErrorCode } from '../error/ErrorCode';

const errorHandler = (err, req, res) => {
    if (err instanceof BusinessError) {
        res.status(err.errorCode.httpStatusCode).json({
            error: {
                code: err.errorCode.code,
                message: err.message,
            },
        });
    } else if (Array.isArray(err) && err[0] instanceof ValidationError) {
        res.status(ErrorCode.VALIDATION_ERROR.httpStatusCode).json({
            error: {
                code: ErrorCode.VALIDATION_ERROR.code,
                message: ErrorCode.VALIDATION_ERROR.message,
            },
        });
    } else {
        throw err;
    }
};

export { errorHandler };
