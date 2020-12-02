import { plainToClass } from 'class-transformer';
import { validate } from 'class-validator';
import { ValidationError } from '../error/ValidationError';

export const validator = async (DtoClass, Object, groups) => {
    const classObject = plainToClass(DtoClass, Object);
    const [error] = await validate(classObject, { groups });
    if (error) {
        throw new ValidationError('validation failed');
    }
};
