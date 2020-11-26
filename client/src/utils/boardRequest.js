import request from './api';

// eslint-disable-next-line import/prefer-default-export
export const getBoards = async () => {
    const config = {
        url: '/api/board',
        method: 'GET',
    };
    const response = await request(config);

    return response;
};
