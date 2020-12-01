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

export const createBoard = async (title) => {
    const config = {
        url: '/api/board',
        method: 'POST',
        data: { title },
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

export const inviteUserIntoBoard = async (boardId, userId) => {
    const config = {
        url: `/api/board/${boardId}/invitation`,
        method: 'POST',
        data: { userId },
    };

    const response = await request(config);

    return response;
};
