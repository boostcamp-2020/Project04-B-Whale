import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Board } from './Board';
import { Card } from './Card';
import { User } from './User';

@Entity()
export class List {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'title', type: 'varchar' })
    title;

    @Column({ name: 'position', type: 'double' })
    position;

    @ManyToOne(() => Board, (board) => board.lists, { nullable: false, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'board_id' })
    board;

    @OneToMany(() => Card, (card) => card.list)
    cards;

    @ManyToOne(() => User, (creator) => creator.lists, { nullable: false })
    @JoinColumn({ name: 'creator_id' })
    creator;
}
