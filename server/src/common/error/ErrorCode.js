const ErrorCode = {
    ENTITY_NOT_FOUND: { code: 1000, httpStatusCode: 404, message: 'Entity is not found' },
    ENTITY_ALREADY_EXIST: { code: 1001, httpStatusCode: 400, message: 'Entity already exists' },
    UNAUTHORIZED: { code: 1002, httpStatusCode: 401, message: 'Unauthorized' },
    FORBIDDEN: { code: 1003, httpStatusCode: 403, message: 'Forbidden' },
    BAD_REQUEST: { code: 1004, httpStatusCode: 400, message: 'Bad Request' },
    VALIDATION_ERROR: { code: 1005, httpStatusCode: 400, message: 'Validation error occurs' },
    CONFLICT: { code: 1006, httpStatusCode: 409, message: 'conflict' },
    INTERNAL_SERVER_ERROR: { code: 5000, httpStatusCode: 500, message: 'Internal Server Error' },
};

export { ErrorCode };
