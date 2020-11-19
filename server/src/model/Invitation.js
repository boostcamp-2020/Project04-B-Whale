import { Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Board } from './Board';
import { User } from './User';

@Entity()
export class Invitation {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @ManyToOne(() => User, (user) => user.invitations, { nullable: false })
    @JoinColumn({ name: 'user_id' })
    user;

    @ManyToOne(() => Board, (board) => board.invitations, { nullable: false })
    @JoinColumn({ name: 'board_id' })
    board;
}
