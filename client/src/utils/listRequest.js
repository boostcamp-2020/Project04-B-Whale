import request from './api';

export const createList = async ({ title, boardId }) => {
    const response = await request({
        url: `/api/board/${boardId}/list`,
        method: 'POST',
        data: { title },
    });

    return response;
};

export const updateListTitle = async ({ listId, title }) => {
    const response = await request({
        url: `/api/list/${listId}`,
        method: 'PATCH',
        data: { title },
    });

    return response;
};

export const deleteList = async ({ listId }) => {
    const response = await request({
        url: `/api/list/${listId}`,
        method: 'DELETE',
    });

    return response;
};

export const modifyListPosition = async ({ listId, position }) => {
    const response = await request({
        url: `/api/list/${listId}`,
        method: 'PATCH',
        data: { position },
    });

    return response;
};
