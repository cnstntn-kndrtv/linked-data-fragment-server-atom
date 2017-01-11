module.exports.Store = class Store {

    constructor(params) {
        this._inMemoryLimit = params.inMemoryLimit || 10000;
        this._dbName = params.dbName || "KloudOne";
        this._storeName = params.storeName || "resultStore";
        this._storeSchema = params.storeSchema || ['s', 'p', 'o'];
        this._storeSchemaKeys

        this._count = 0;
        this._initInMemoryDB()
        this._initIndexDB();

        this._db = this._inMemoryDB;
    }

    set inMemoryLimit(limit) {
        this._inMemoryLimit = limit
    }
    get inMemoryLimit() {
        return this._inMemoryLimit
    }

    _initInMemoryDB() {
        this._inMemoryDB = new InMemoryDB(this._dbName, this._storeName, this._storeSchema);
    }

    _initIndexDB() {
        this._indexedDB = new IndexedDB(this._dbName, this._storeName, this._storeSchema);
    }

    put(data) {
        return new Promise((resolve, reject) => {
            this._db.put(data)
                .then(() => {
                    this._count++;
                    if (this._count > this._inMemoryLimit && this._db !== this._indexedDB) {
                        this._db = this._indexedDB;
                        this._combine();
                    } else if (this._count < this._inMemoryLimit) this._db = this._inMemoryDB;
                })
                .then(() => {
                    resolve()
                });
        });
    }

    get(key) {
        return new Promise((resolve, reject) => {
            this._db.get(key)
                .then((res) => {
                    //console.log('get', this._db.__proto__.constructor.name, res);
                    resolve(res)
                });
        });
    }

    clear() {
        return new Promise((resolve, reject) => {
            // this._db.clear()
            Promise.all([
                this._inMemoryDB.clear(),
                this._indexedDB.clear()
            ]).then(() => {
                this._count = 0;
                resolve();
            })
        });
    }

    getAll(key) {
        return new Promise((resolve, reject) => {
            this._db.getAll(key)
                .then((res) => {
                    //console.log('get All', this._db.__proto__.constructor.name, res);
                    resolve(res)
                })
        })
    }

    count() {
        return new Promise((resolve, reject) => {
            // Promise.all([
            //     this._inMemoryDB.count(),
            //     this._indexedDB.count()
            // ]).then((result) => {
            //     console.log('mem', result[0], 'ind', result[1]);
            // });

            resolve(this._count);
        });
    }

    _combine(){
        return new Promise((resolve, reject) => {
            if (this._db !== this._inMemoryDB && this._count > this._inMemoryLimit) {
                this._inMemoryDB.getAll()
                    .then((results) => {
                        results.forEach((res) => {
                            this._indexedDB.put(res)
                        });
                    })
                    .then(() => this._inMemoryDB.clear())
                    .then(() => resolve());
            }
        });
    }
}
