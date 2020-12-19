import request from './request';

export const addComment = async ({ cardId, content }) => {
    const response = await request({
        url: `/api/card/${cardId}/comment`,
        method: 'POST',
        data: { content },
    });

    return response;
};

export const modifyComment = async ({ commentId, commentContent }) => {
    const response = await request({
        url: `/api/comment/${commentId}`,
        method: 'PATCH',
        data: { content: commentContent },
    });

    return response;
};

export const deleteComment = async ({ commentId }) => {
    const response = await request({
        url: `/api/comment/${commentId}`,
        method: 'DELETE',
    });

    return response;
};
