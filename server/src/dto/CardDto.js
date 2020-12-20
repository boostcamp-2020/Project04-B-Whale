import { IsISO8601, IsNotEmpty, IsNumber, IsString, ValidateIf } from 'class-validator';

export class CardDto {
    id;

    @ValidateIf((o) => o.title !== undefined)
    @IsString()
    @IsNotEmpty()
    title;

    @ValidateIf((o) => o.content !== undefined)
    @IsString()
    content;

    @ValidateIf((o) => o.position !== undefined)
    @IsNumber()
    position;

    @ValidateIf((o) => o.dueDate !== undefined)
    @IsISO8601()
    dueDate;

    @ValidateIf((o) => o.listId !== undefined)
    @IsNumber()
    listId;
}
