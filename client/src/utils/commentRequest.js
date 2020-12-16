import request from './request';

export const addComment = async ({ cardId, content }) => {
    const response = await request({
        url: `/api/card/${cardId}/comment`,
        method: 'POST',
        data: { content },
    });

    return response;
};
