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

export const modifyCardPosition = async ({ cardId, listId, position }) => {
    const config = {
        url: `/api/card/${cardId}`,
        method: 'PATCH',
        data: { listId, position },
    };
    const response = await request(config);

    return response;
};
