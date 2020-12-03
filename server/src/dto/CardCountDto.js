import { IsOptional, IsString, Matches } from 'class-validator';

export class CardCountDto {
    @IsString({ groups: ['isQuery'] })
    q;

    @IsString({ groups: ['queryValue'] })
    @Matches(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/, { groups: ['queryValue'] })
    startDate;

    @IsString({ groups: ['queryValue'] })
    @Matches(/[0-9]{4}-[0-9]{2}-[0-9]{2}$/, { groups: ['queryValue'] })
    endDate;

    @IsOptional({ groups: ['queryValue'] })
    @IsString({ groups: ['queryValue'] })
    @Matches(/me/, { groups: ['queryValue'] })
    member;
}
