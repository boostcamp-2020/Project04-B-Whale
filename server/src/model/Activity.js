import {
    Column,
    Entity,
    JoinColumn,
    ManyToOne,
    PrimaryGeneratedColumn,
    CreateDateColumn,
} from 'typeorm';
import { Board } from './Board';

@Entity()
export class Activity {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'content', type: 'varchar', charset: 'utf8mb4' })
    content;

    @ManyToOne(() => Board, (board) => board.activities, { nullable: false })
    @JoinColumn({ name: 'board_id' })
    board;

    @CreateDateColumn({ name: 'created_at', type: 'datetime' })
    createdAt;
}
