const delimiter = ':';
const separator = ' ';

export const queryParser = (queryString) => {
    if (typeof queryString !== 'string') return null;

    const result = {};

    queryString.split(separator).forEach((ele) => {
        const keyValue = ele.split(delimiter);
        const key = keyValue[0];
        const value = keyValue[1];

        result[key] = value;
    });

    return result;
};
