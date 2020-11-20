import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Board } from './Board';
import { Card } from './Card';

@Entity()
export class List {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'title', type: 'varchar' })
    title;

    @Column({ name: 'position', type: 'double' })
    position;

    @ManyToOne(() => Board, (board) => board.lists, { nullable: false })
    @JoinColumn({ name: 'board_id' })
    board;

    @OneToMany(() => Card, (card) => card.list)
    cards;
}
