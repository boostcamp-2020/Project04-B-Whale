import { BusinessError } from './BusinessError';
import { ErrorCode } from './ErrorCode';

export class ForbiddenError extends BusinessError {
    constructor(message) {
        super(ErrorCode.FORBIDDEN, message);
    }
}
