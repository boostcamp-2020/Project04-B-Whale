import { IsNumber, IsString, Matches } from 'class-validator';

export class BoardDto {
    @IsNumber()
    id;

    @IsString()
    title;

    @IsString()
    @Matches('^#[a-fA-F0-9]{6}$')
    color;
}
