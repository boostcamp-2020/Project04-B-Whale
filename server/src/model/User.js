import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Board } from './Board';
import { Card } from './Card';
import { Comment } from './Comment';
import { Invitation } from './Invitation';
import { List } from './List';
import { Member } from './Member';

@Entity()
export class User {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'social_id', type: 'varchar', charset: 'utf8mb4' })
    socialId;

    @Column({ name: 'name', type: 'varchar', charset: 'utf8mb4' })
    name;

    @Column({ name: 'profile_image_url', type: 'varchar', charset: 'utf8mb4' })
    profileImageUrl;

    @OneToMany(() => Board, (board) => board.creator)
    boards;

    @OneToMany(() => Invitation, (invitation) => invitation.user)
    invitations;

    @OneToMany(() => Comment, (comment) => comment.user)
    comments;

    @OneToMany(() => Member, (member) => member.user)
    members;

    @OneToMany(() => Card, (card) => card.creator)
    cards;

    @OneToMany(() => List, (list) => list.creator)
    lists;
}
