import { IsISO8601, IsOptional, IsString, Matches } from 'class-validator';

export class GetCardsByDateQueryDto {
    @IsISO8601({ strict: true })
    @Matches(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/)
    date;

    @IsOptional()
    @IsString()
    member;
}
