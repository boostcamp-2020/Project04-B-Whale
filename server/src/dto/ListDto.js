import { IsNumber, IsString } from 'class-validator';

export class ListDto {
    @IsNumber()
    id;

    @IsString()
    title;

    @IsNumber()
    position;
}
