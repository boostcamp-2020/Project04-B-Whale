const delimiter = ':';
const separator = ' ';

export const queryParser = (queryString) => {
    if (typeof queryString !== 'string') return null;

    const result = {};

    queryString.split(separator).forEach((ele) => {
        const [key, value] = ele.split(delimiter);

        result[key] = value;
    });

    return result;
};
