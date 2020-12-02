import {
    getEntityManagerOrTransactionManager,
    Transactional,
} from 'typeorm-transactional-cls-hooked';

export class TestTransactionDelegate {
    static SAVEPOINT = 'here';

    @Transactional()
    static async transaction(callback) {
        const em = getEntityManagerOrTransactionManager('default');
        await em.query(`SAVEPOINT ${TestTransactionDelegate.SAVEPOINT}`);
        await callback();
        await em.query(`ROLLBACK TO ${TestTransactionDelegate.SAVEPOINT}`);
    }
}
