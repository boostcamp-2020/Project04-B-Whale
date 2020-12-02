import {
    getEntityManagerOrTransactionManager,
    Transactional,
} from 'typeorm-transactional-cls-hooked';

export class TestTransactionDelegate {
    @Transactional()
    static async transaction(callback) {
        const entityManager = getEntityManagerOrTransactionManager();
        await entityManager.query('SAVEPOINT STARTPOINT');
        await callback();
        await entityManager.query('ROLLBACK TO STARTPOINT');
    }
}
