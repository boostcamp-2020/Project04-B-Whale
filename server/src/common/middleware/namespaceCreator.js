import { createNamespace, getNamespace } from 'cls-hooked';

const namespaceCreator = (req, res, next) => {
    const namespace = getNamespace('localstorage') || createNamespace('localstorage');
    namespace.run(() => {
        next();
    });
};

export { namespaceCreator };
