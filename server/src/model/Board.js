import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Activity } from './Activity';
import { Invitation } from './Invitation';
import { List } from './List';
import { User } from './User';

@Entity()
export class Board {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'title', type: 'varchar', charset: 'utf8mb4' })
    title;

    @Column({ name: 'color', type: 'varchar', charset: 'utf8mb4' })
    color;

    @ManyToOne(() => User, (user) => user.boards, { nullable: false })
    @JoinColumn({ name: 'creator_id' })
    creator;

    @OneToMany(() => Invitation, (invitation) => invitation.board)
    invitations;

    @OneToMany(() => List, (list) => list.board)
    lists;

    @OneToMany(() => Activity, (activity) => activity.board)
    activities;
}
