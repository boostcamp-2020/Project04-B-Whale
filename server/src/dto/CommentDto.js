import { Expose, Type } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CommentDto {
    @IsNumber({}, { groups: ['MODIFY_COMMENT'] })
    @Type(() => Number)
    @Expose()
    id;

    @IsString({ groups: ['MODIFY_COMMENT'] })
    @IsNotEmpty({ groups: ['MODIFY_COMMENT'] })
    @Type(() => String)
    @Expose()
    content;

    constructor(id, content) {
        this.id = id;
        this.content = content;
    }
}
