import {
    Column,
    CreateDateColumn,
    Entity,
    JoinColumn,
    ManyToOne,
    PrimaryGeneratedColumn,
} from 'typeorm';
import { Card } from './Card';
import { User } from './User';

@Entity()
export class Comment {
    @PrimaryGeneratedColumn('increment', { type: 'int' })
    id;

    @Column({ name: 'content', type: 'varchar' })
    content;

    @CreateDateColumn({ name: 'created_at', type: 'datetime' })
    createdAt;

    @ManyToOne(() => User, (user) => user.comments, { nullable: false })
    @JoinColumn({ name: 'user_id' })
    user;

    @ManyToOne(() => Card, (card) => card.comments, { nullable: false })
    @JoinColumn({ name: 'card_id' })
    card;

    updateContent(content) {
        if (this.content === content) {
            return false;
        }
        this.content = content;
        return true;
    }
}
