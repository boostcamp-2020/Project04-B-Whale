import request from './request';

export const getCardCount = async ({ startDate, endDate, member }) => {
    const config = {
        url: member
            ? `/api/card/count?q=startdate:${startDate} enddate:${endDate} member:${member}`
            : `/api/card/count?q=startdate:${startDate} enddate:${endDate}`,
        method: 'GET',
    };
    const response = await request(config);

    return response;
};

export const getCardsByDueDate = async ({ dueDate, member }) => {
    const response = await request({
        url:
            member !== undefined
                ? `/api/card?q=date:${dueDate} member:${member}`
                : `/api/card?q=date:${dueDate}`,
        method: 'GET',
    });

    return response;
};

export const modifyCardDueDate = async ({ cardId, dueDate }) => {
    const config = {
        url: `/api/card/${cardId}`,
        method: 'PATCH',
        data: { dueDate },
    };
    const response = await request(config);

    return response;
};

export const createCard = async ({ listId, title, content, dueDate }) => {
    const config = {
        url: `/api/list/${listId}/card`,
        method: 'POST',
        data: { title, content, dueDate },
    };
    const response = await request(config);

    return response;
};

export const addMemberToCard = async ({ cardId, userIds }) => {
    const config = {
        url: `/api/card/${cardId}/member`,
        method: 'PUT',
        data: { userIds },
    };
    const response = await request(config);

    return response;
};

export const deleteCard = async (cardId) => {
    const config = {
        url: `/api/card/${cardId}`,
        method: 'DELETE',
    };
    const response = await request(config);

    return response;
};

export const modifyCardPosition = async ({ cardId, listId, position }) => {
    const config = {
        url: `/api/card/${cardId}`,
        method: 'PATCH',
        data: { listId, position },
    };
    const response = await request(config);

    return response;
};

export const getCard = async ({ cardId }) => {
    const response = await request({ url: `/api/card/${cardId}`, method: 'GET' });
    return response;
};

export const modifyCardTitle = async ({ cardId, cardTitle }) => {
    const response = await request({
        url: `/api/card/${cardId}`,
        method: 'PATCH',
        data: { title: cardTitle },
    });
    return response;
};

export const modifyCardContent = async ({ cardId, cardContent }) => {
    const response = await request({
        url: `/api/card/${cardId}`,
        method: 'PATCH',
        data: { content: cardContent },
    });
    return response;
};

export const removeCard = async ({ cardId }) => {
    const response = await request({
        url: `/api/card/${cardId}`,
        method: 'DELETE',
    });
    return response;
};
