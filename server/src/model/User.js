import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Board } from './Board';
import { Comment } from './Comment';
import { Invitation } from './Invitation';
import { Member } from './Member';

@Entity()
export class User {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'social_id', type: 'varchar' })
    socialId;

    @Column({ name: 'name', type: 'varchar' })
    name;

    @Column({ name: 'profile_image_url', type: 'varchar' })
    profileImageUrl;

    @OneToMany(() => Board, (board) => board.creator)
    boards;

    @OneToMany(() => Invitation, (invitation) => invitation.user)
    invitations;

    @OneToMany(() => Comment, (comment) => comment.user)
    comments;

    @OneToMany(() => Member, (member) => member.user)
    members;
}
