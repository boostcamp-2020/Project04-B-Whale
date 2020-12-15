import { Column, Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Board } from './Board';

@Entity()
export class Activity {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'content', type: 'varchar' })
    content;

    @ManyToOne(() => Board, (board) => board.activities, { nullable: false, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'board_id' })
    board;
}
