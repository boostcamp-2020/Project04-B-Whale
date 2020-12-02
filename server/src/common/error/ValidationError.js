import { BusinessError } from './BusinessError';
import { ErrorCode } from './ErrorCode';

export class ValidationError extends BusinessError {
    constructor(message) {
        super(ErrorCode.VALIDATION_ERROR, message);
    }
}
