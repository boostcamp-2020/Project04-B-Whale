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
        const reg = /^Bearer /;
        const token = localStorage.getItem('jwt');
        if (token === null || !reg.test(token)) window.location.href = '/login';
        newConfig.headers.Authorization = localStorage.getItem('jwt');
        return newConfig;
    },
    (error) => Promise.reject(error),
);

instance.interceptors.response.use(
    (response) => {
        return response;
    },

    (error) => {
        const { status } = error.response;
        if (status === 401) window.location.href = '/login';
        return error.response;
    },
);

export default instance;
