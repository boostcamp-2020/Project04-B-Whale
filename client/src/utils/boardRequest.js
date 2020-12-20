import request from './api';

export const getBoards = async () => {
    const config = {
        url: '/api/board',
        method: 'GET',
    };
    const response = await request(config);

    return response;
};

export const createBoard = async ({ title, color }) => {
    const config = {
        url: '/api/board',
        method: 'POST',
        data: { title, color },
    };
    const response = await request(config);

    return response;
};

export const getDetailBoard = async (id) => {
    const config = {
        url: `/api/board/${id}`,
        method: 'GET',
    };

    const response = await request(config);

    return response;
};
