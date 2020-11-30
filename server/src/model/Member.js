import { Entity, JoinColumn, ManyToOne, PrimaryGeneratedColumn } from 'typeorm';
import { Card } from './Card';
import { User } from './User';

@Entity()
export class Member {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @ManyToOne(() => User, (user) => user.members, { nullable: false })
    @JoinColumn({ name: 'user_id' })
    user;

    @ManyToOne(() => Card, (card) => card.members, { nullable: false })
    @JoinColumn({ name: 'card_id' })
    card;
}
