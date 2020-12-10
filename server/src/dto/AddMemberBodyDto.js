import { IsArray, IsString, Matches } from 'class-validator';

export class AddMemberBodyDto {
    @IsString()
    @Matches(/^[0-9]{1,}/)
    cardId;

    @IsArray()
    userIds;
}
