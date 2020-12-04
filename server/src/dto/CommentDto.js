import { IsNumber, IsString } from 'class-validator';

export class CommentDto {
    @IsNumber()
    id;

    @IsString()
    content;
}
