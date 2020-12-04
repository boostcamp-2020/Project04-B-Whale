import request from './api';

// eslint-disable-next-line import/prefer-default-export
export const getCardCount = async ({ startDate, endDate }) => {
    const config = {
        url: `/api/card/count?q=startdate:${startDate} enddate:${endDate}`,
        method: 'GET',
    };
    const response = await request(config);

    return response;
};
