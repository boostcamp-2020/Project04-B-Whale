import { Column, Entity, JoinColumn, ManyToOne, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Comment } from './Comment';
import { List } from './List';
import { Member } from './Member';
import { User } from './User';

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

    @ManyToOne(() => List, (list) => list.cards, { nullable: false, onDelete: 'CASCADE' })
    @JoinColumn({ name: 'list_id' })
    list;

    @OneToMany(() => Comment, (comment) => comment.card)
    comments;

    @OneToMany(() => Member, (member) => member.card)
    members;

    @ManyToOne(() => User, (creator) => creator.cards, { nullable: false })
    @JoinColumn({ name: 'creator_id' })
    creator;
}
