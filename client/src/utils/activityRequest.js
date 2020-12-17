import request from './request';

export const getActivities = async (boardId) => {
    const config = {
        url: `/api/activity?boardId=${boardId}`,
        method: 'GET',
    };
    const response = await request(config);

    return response;
};
