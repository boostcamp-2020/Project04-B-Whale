import { createNamespace, getNamespace } from 'cls-hooked';

const subscriber = (req, res, next) => {
    const namespace = getNamespace('localstorage') || createNamespace('localstorage');
    namespace.run(() => {
        next();
    });
};

export { subscriber };
