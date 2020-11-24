import { BusinessError } from './BusinessError';
import { ErrorCode } from './ErrorCode';

export class EntityNotFoundError extends BusinessError {
    constructor(message) {
        super(ErrorCode.ENTITY_NOT_FOUND, message);
    }
}
