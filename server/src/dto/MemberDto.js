import { IsNumber } from 'class-validator';

export class MemberDto {
    @IsNumber()
    id;

    @IsNumber()
    card;

    @IsNumber()
    user;
}
