import { Column, Entity, JoinColumn, ManyToMany, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Card } from './Card';
import { User } from './User';

@Entity()
export class Comment {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @ManyToOne(() => User, (user) => user.comments, { nullable: false })
    @JoinColumn({ name: 'user_id' })
    user;

    @ManyToOne(() => Card, (card) => card.comments, { nullable: false })
    @JoinColumn({ name: 'card_id' })
    card;
}
