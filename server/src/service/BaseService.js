import { getCustomRepository, getRepository } from 'typeorm';
import { CustomBoardRepository } from '../dao/CustomBoardRepository';
import { CustomCardRepository } from '../dao/CustomCardRepository';
import { CustomListRepository } from '../dao/CustomListRepository';
import { CustomUserRepository } from '../dao/CustomUserRepository';
import { Activity } from '../model/Activity';
import { Board } from '../model/Board';
import { Card } from '../model/Card';
import { Comment } from '../model/Comment';
import { Invitation } from '../model/Invitation';
import { List } from '../model/List';
import { Member } from '../model/Member';
import { User } from '../model/User';

export class BaseService {
    constructor() {
        this.activityRepository = getRepository(Activity);
        this.boardRepository = getRepository(Board);
        this.cardRepository = getRepository(Card);
        this.commentRepository = getRepository(Comment);
        this.invitationRepository = getRepository(Invitation);
        this.listRepository = getRepository(List);
        this.userRepository = getRepository(User);
        this.memberRepository = getRepository(Member);
        this.customBoardRepository = getCustomRepository(CustomBoardRepository);
        this.customCardRepository = getCustomRepository(CustomCardRepository);
        this.customUserRepository = getCustomRepository(CustomUserRepository);
        this.customListRepository = getCustomRepository(CustomListRepository);
    }
}
