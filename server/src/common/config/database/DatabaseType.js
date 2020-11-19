const DatabaseType = {
    MYSQL: 'mysql',
    SQLITE: 'sqlite',
    valueOf: (typeString) => {
        return Object.keys(DatabaseType)
            .filter((value) => DatabaseType[value] === typeString)
            .reduce((value) => value, null);
    },
    values: () => Object.values(DatabaseType).filter((value) => typeof value === 'string'),
    contains: (db) => DatabaseType.values().filter((value) => value === db).length !== 0,
};

export { DatabaseType };
