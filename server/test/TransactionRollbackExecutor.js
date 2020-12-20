import {
    getEntityManagerOrTransactionManager,
    Transactional,
} from 'typeorm-transactional-cls-hooked';

export class TransactionRollbackExecutor {
    static SAVEPOINT = 'here';

    @Transactional()
    static async rollback(callback) {
        const em = getEntityManagerOrTransactionManager('default');
        await callback();
        await em.query('ROLLBACK');
    }
}
