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

export const deleteCard = async (cardId) => {
    const config = {
        url: `/api/card/${cardId}`,
        method: 'DELETE',
    };
    const response = await request(config);

    return response;
};
