import { decode } from 'jsonwebtoken';
import { JwtUtil } from '../../../src/common/util/JwtUtil';

const secret = 'secret';
const jwtUtil = new JwtUtil(secret);

describe('JwtUtil.generateAccessToken() Test', () => {
    test('access token 생성 후 payload 비교', async () => {
        // given
        const payload = { id: 0 };

        // when
        const token = await jwtUtil.generateAccessToken(payload);

        // then
        const bearer = token.split(' ')[0];
        const jwt = token.split(' ')[1];

        expect(bearer).toEqual('Bearer');
        expect(decode(jwt)?.id).toEqual(0);
    });
});

describe('JwtUtil.validateAccessToken() Test', () => {
    test('access token 생성 후 검증', async () => {
        // given
        const payload = { id: 0 };
        const token = await jwtUtil.generateAccessToken(payload);

        // when
        const decoded = await jwtUtil.validateAccessToken(token);

        // then
        expect(decoded?.id).toEqual(0);
    });

    test('잘못된 secret으로 암호화된 access token 검증 실패', async () => {
        // given
        const token =
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MCwiaWF0IjoxNTE2MjM5MDIyfQ.qwzCEHw1sJkXiV6fVGfasuDIrr0WYz78E3JdgC9AdoM';

        try {
            // when
            await jwtUtil.validateAccessToken(token);
            fail();
        } catch (error) {
            // then
            expect(error).toBeInstanceOf(Error);
        }
    });
});

describe('JwtUtil.matchBearer() Test', () => {
    test('Bearer 매칭', async () => {
        // given
        const a = 'Bearer token';
        const b = 'token';

        // when
        // then
        expect(jwtUtil.matchBearer(a)).toBeTruthy();
        expect(jwtUtil.matchBearer(b)).toBeFalsy();
    });
});
