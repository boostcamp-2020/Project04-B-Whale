import { Type } from 'class-transformer';
import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CommentDto {
    @IsNumber({ groups: ['MODIFY_COMMENT'] })
    @Type(() => Number)
    id;

    @IsString({ groups: ['MODIFY_COMMENT'] })
    @IsNotEmpty({ groups: ['MODIFY_COMMENT'] })
    @Type(() => String)
    content;

    constructor(id, content) {
        this.id = id;
        this.content = content;
    }
}
