/* eslint-disable no-alert */
import axios from 'axios';

const token = localStorage.getItem('jwt');

const instance = axios.create({
    baseURL: process.env.REACT_APP_BASE_URL,
    timeout: 1000,
    headers: {
        Authorization: token,
        'Content-Type': 'application/json',
    },
});

instance.interceptors.request.use(
    (config) => config,
    (error) => Promise.reject(error),
);

instance.interceptors.response.use(
    (response) => {
        const { status } = response;
        switch (status) {
            case 200:
            case 204:
                break;
            case 201:
                alert('정상적으로 생성되었습니다.');
                break;
            default:
                break;
        }
        return response;
    },

    (error) => {
        const { status } = error.response;
        switch (status) {
            case 400:
            case 409:
                alert('입력 값을 확인해주세요.');
                break;
            case 401:
                window.location.href = '/login';
                break;
            case 403:
                alert('권한이 없습니다.');
                break;
            case 404:
                alert('알 수 없는 요청입니다');
                break;
            default:
                alert('이유를 알 수 없는 오류입니다.');
        }
    },
);

export default instance;
