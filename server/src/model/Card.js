import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Comment } from './Comment';
import { List } from './List';

@Entity()
export class Card {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'title', type: 'varchar' })
    title;

    @Column({ name: 'content', type: 'varchar' })
    content;

    @Column({ name: 'position', type: 'double' })
    position;

    @Column({ name: 'due_date', type: 'datetime' })
    dueDate;

    @ManyToOne(() => List, (list) => list.cards, { nullable: false })
    @JoinColumn({ name: 'list_id' })
    list;

    @OneToMany(() => Comment, (comment) => comment.card)
    comments;
}
