import { BusinessError } from './BusinessError';
import { ErrorCode } from './ErrorCode';

export class BadRequestError extends BusinessError {
    constructor(message) {
        super(ErrorCode.BAD_REQUEST, message);
    }
}
