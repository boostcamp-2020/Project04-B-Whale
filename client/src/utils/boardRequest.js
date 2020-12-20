import request from './request';

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

export const inviteUserIntoBoard = async (boardId, userId) => {
    const config = {
        url: `/api/board/${boardId}/invitation`,
        method: 'POST',
        data: { userId },
    };

    const response = await request(config);

    return response;
};

export const updateBoardTitle = async (boardId, title) => {
    const config = {
        url: `/api/board/${boardId}`,
        method: 'PUT',
        data: { title },
    };

    const response = await request(config);

    return response;
};

export const removeBoard = async (boardId) => {
    const config = {
        url: `/api/board/${boardId}`,
        method: 'DELETE',
    };

    const response = await request(config);

    return response;
};

export const exitBoard = async (boardId) => {
    const config = {
        url: `/api/board/${boardId}/invitation`,
        method: 'DELETE',
    };

    const response = await request(config);

    return response;
};
