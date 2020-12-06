import { IsISO8601, IsOptional, IsString, Matches } from 'class-validator';

export class CardCountDto {
    @IsString({ groups: ['isQuery'] })
    q;

    @IsISO8601({ strict: true }, { groups: ['queryValue'] })
    @Matches(/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/, { groups: ['queryValue'] })
    startDate;

    @IsISO8601({ strict: true }, { groups: ['queryValue'] })
    @Matches(/[0-9]{4}-[0-9]{2}-[0-9]{2}$/, { groups: ['queryValue'] })
    endDate;

    @IsOptional({ groups: ['queryValue'] })
    @IsString({ groups: ['queryValue'] })
    @Matches(/me/, { groups: ['queryValue'] })
    member;
}
