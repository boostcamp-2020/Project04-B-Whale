import { IsArray, ValidateIf } from 'class-validator';

export class MemberDto {
    id;

    card;

    user;

    @ValidateIf((o) => o.user)
    @IsArray()
    userIds;
}
