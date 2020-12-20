import { plainToClass } from 'class-transformer';
import { validateOrReject } from 'class-validator';

export const validator = async (DtoClass, Object, groups = []) => {
    const classObject = plainToClass(DtoClass, Object);
    await validateOrReject(classObject, { groups });
};
