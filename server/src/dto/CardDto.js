import { IsDateString, IsNumber, IsString } from 'class-validator';

export class CardDto {
    @IsNumber()
    id;

    @IsString()
    title;

    @IsString()
    content;

    @IsNumber()
    position;

    @IsDateString()
    dueDate;
}
