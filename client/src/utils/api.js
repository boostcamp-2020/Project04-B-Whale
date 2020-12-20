import axios from 'axios';

/**
 * @param {'get' | 'post' | 'put' | 'delete'} method
 * @param {string} url
 * @param {object} query
 * @param {object} data (method === 'POST' or 'PUT')
 */

const request = async (config) => {
    try {
        const token = localStorage.getItem('jwt');

        const res = await axios({
            headers: {
                Authorization: token,
                'Content-Type': 'application/json',
            },
            ...config,
            url: process.env.REACT_APP_BASE_URL + config.url,
        });
        return { status: res.status, data: res.data };
    } catch ({ response }) {
        return { status: response.status };
    }
};

export default request;
