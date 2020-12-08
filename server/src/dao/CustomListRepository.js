import { EntityRepository } from 'typeorm';
import { BaseRepository } from 'typeorm-transactional-cls-hooked';
import { List } from '../model/List';

@EntityRepository(List)
export class CustomListRepository extends BaseRepository {}
