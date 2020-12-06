import request from './api';

// eslint-disable-next-line import/prefer-default-export
export const searchUsersByName = async (name) => {
    const config = {
        url: `/api/user?username=${name}`,
        method: 'GET',
    };
    const response = await request(config);

    return response;
};
