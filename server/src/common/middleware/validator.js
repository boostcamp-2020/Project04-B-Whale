import { validateOrReject } from 'class-validator';

const validator = (reqTypes) => {
    return async (req, res, next) => {
        await Promise.all(reqTypes.map((type) => validateOrReject(req[type])));
        next();
    };
};

export { validator };
