import { BusinessError } from './BusinessError';
import { ErrorCode } from './ErrorCode';

export class InternalServerError extends BusinessError {
    constructor(message) {
        super(ErrorCode.INTERNAL_SERVER_ERROR, message);
    }
}
