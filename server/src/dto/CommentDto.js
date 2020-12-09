import { IsNumber, IsString } from 'class-validator';

export class CommentDto {
    @IsNumber()
    id;

    @IsString()
    content;

    constructor({ id, content }) {
        this.id = id;
        this.content = content;
    }
}
