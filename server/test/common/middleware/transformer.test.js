/* eslint-disable max-classes-per-file */
import { createRequest, createResponse } from 'node-mocks-http';
import { RequestType } from '../../../src/common/middleware/RequestType';
import { transformer } from '../../../src/common/middleware/transformer';

class TestRequest {
    constructor() {
        this.firstField = null;
        this.secondField = null;
        this.thirdField = null;
        this.fourthField = null;
    }
}

describe('Transformer Test', () => {
    test('Request Body에 포함된 내용을 TestRequest로 변환', async () => {
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
        const middleware = transformer([RequestType.BODY], [TestRequest]);

        // when
        middleware(request, response, () => {});

        // then
        expect(request.body).toBeInstanceOf(TestRequest);
        expect(request.body.firstField).toEqual(0);
        expect(request.body.secondField).toEqual(1);
        expect(request.body.thirdField).toEqual(2);
        expect(request.body.fourthField).toEqual(3);
    });

    test('Request Query에 포함된 내용을 TestRequest로 변환', async () => {
        // given
        const request = createRequest({
            query: {
                firstField: 0,
                secondField: 1,
                thirdField: 2,
                fourthField: 3,
            },
        });
        const response = createResponse();
        const middleware = transformer([RequestType.QUERY], [TestRequest]);

        // when
        middleware(request, response, () => {});

        // then
        expect(request.query).toBeInstanceOf(TestRequest);
        expect(request.query.firstField).toEqual(0);
        expect(request.query.secondField).toEqual(1);
        expect(request.query.thirdField).toEqual(2);
        expect(request.query.fourthField).toEqual(3);
    });

    test('Request Params에 포함된 내용을 TestRequest로 변환', async () => {
        // given
        const request = createRequest({
            params: {
                firstField: 0,
                secondField: 1,
                thirdField: 2,
                fourthField: 3,
            },
        });
        const response = createResponse();
        const middleware = transformer([RequestType.PARAMS], [TestRequest]);

        // when
        middleware(request, response, () => {});

        // then
        expect(request.params).toBeInstanceOf(TestRequest);
        expect(request.params.firstField).toEqual(0);
        expect(request.params.secondField).toEqual(1);
        expect(request.params.thirdField).toEqual(2);
        expect(request.params.fourthField).toEqual(3);
    });
});
