/* eslint-disable max-classes-per-file */
import { IsNumber, ValidationError } from 'class-validator';
import { createRequest, createResponse } from 'node-mocks-http';
import { RequestType } from '../../../src/common/middleware/RequestType';
import { transformer } from '../../../src/common/middleware/transformer';
import { validator } from '../../../src/common/middleware/validator';

class TestRequest {
    @IsNumber()
    firstField;

    @IsNumber()
    secondField;

    @IsNumber()
    thirdField;

    @IsNumber()
    fourthField;

    constructor() {
        this.firstField = null;
        this.secondField = null;
        this.thirdField = null;
        this.fourthField = null;
    }
}

describe('Validator Test', () => {
    test('Request Body 유효성 검사 통과', async () => {
        // given
        const request = createRequest({
            body: {
                firstField: 0,
                secondField: 1,
                thirdField: 2,
                fourthField: 3,
            },
        });
        const response = createResponse();
        const trasfromMiddleware = transformer([RequestType.BODY], [TestRequest]);
        const validateMiddleware = validator([RequestType.BODY]);
        trasfromMiddleware(request, response, () => {});

        // when
        // then
        try {
            await validateMiddleware(request, response, () => {});
        } catch (errors) {
            fail();
        }
    });

    test('Request Body 유효성 검사 에러 발생', async () => {
        // given
        const request = createRequest({
            body: {
                firstField: 0,
                secondField: 1,
                thirdField: 2,
                fourthField: 'error',
            },
        });
        const response = createResponse();
        const trasfromMiddleware = transformer([RequestType.BODY], [TestRequest]);
        const validateMiddleware = validator([RequestType.BODY]);
        trasfromMiddleware(request, response, () => {});

        // when
        // then
        try {
            await validateMiddleware(request, response, () => {});
            fail();
        } catch (errors) {
            errors.forEach((error) => {
                expect(error).toBeInstanceOf(ValidationError);
            });
        }
    });
});
