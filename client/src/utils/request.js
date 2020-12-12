/* eslint-disable no-alert */
import axios from 'axios';

const instance = axios.create({
    baseURL: process.env.REACT_APP_BASE_URL,
    timeout: 1000,
    headers: {
        'Content-Type': 'application/json',
    },
});

instance.interceptors.request.use(
    (config) => {
        const newConfig = config;
        newConfig.headers.Authorization = localStorage.getItem('jwt');
        return newConfig;
    },
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
        const { status, data } = error.response;
        switch (status) {
            case 400:
            case 409:
                alert(data.error.message);
                break;
            case 401:
                window.location.href = '/login';
                break;
            case 403:
                alert(data.error.message);
                break;
            case 404:
                alert(data.error.message);
                break;
            default:
                alert(data.error.message);
        }
    },
);

export default instance;
