import request from './request';

export const searchUsersByName = async (name) => {
    const config = {
        url: `/api/user?username=${name}`,
        method: 'GET',
    };
    const response = await request(config);

    return response;
};

export const getMyInfo = async () => {
    const config = {
        url: `/api/user/me`,
        method: 'GET',
    };
    const response = await request(config);

    return response;
};
