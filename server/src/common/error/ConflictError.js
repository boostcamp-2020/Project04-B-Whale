import { BusinessError } from './BusinessError';
import { ErrorCode } from './ErrorCode';

export class ConflictError extends BusinessError {
    constructor(message) {
        super(ErrorCode.CONFLICT, message);
    }
}
