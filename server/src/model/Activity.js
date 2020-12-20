import moment from 'moment-timezone';
import {
    BeforeInsert,
    Column,
    Entity,
    JoinColumn,
    ManyToOne,
    PrimaryGeneratedColumn,
} from 'typeorm';
import { Board } from './Board';

@Entity()
export class Activity {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'content', type: 'varchar', charset: 'utf8mb4' })
    content;

    @ManyToOne(() => Board, (board) => board.activities, { nullable: false, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'board_id' })
    board;

    @Column({ name: 'created_at', type: 'datetime' })
    createdAt;

    @BeforeInsert()
    beforeInsert() {
        if (this.createdAt === null || this.createdAt === undefined) {
            this.createdAt = moment().tz('Asia/Seoul').format();
        }
    }
}
