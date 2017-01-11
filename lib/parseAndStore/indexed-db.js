let {InterfaceDB} = require('./InterfaceDB.js');

module.exports.IndexedDB = class IndexedDB extends InterfaceDB {
    constructor(baseName, storeName, storeSchema) {
        super();
        this._init(baseName, storeName, storeSchema);
    }

    _init(baseName, storeName, storeSchema) {
        this._baseName = baseName;
        this._storeName = storeName;
        this._db = indexedDB;
        console.log(this._db);
        this._storeSchemaKeys = storeSchema;
        //this._storeSchemaKeyPath = {keyPath: "id", autoIncrement: true};
        this._storeSchemaKeyPath = {keyPath: this._storeSchemaKeys};

    }

    _connectDB(cb) {
        let request = this._db.open(this._baseName, 1);
        request.onerror = this.logger;
        request.onsuccess = () => cb(request.result);
        request.onupgradeneeded = (event) => {
            let objectStore = event.currentTarget.result.createObjectStore(this._storeName, this._storeSchemaKeyPath);
            // indexes for each key
            this._storeSchemaKeys.forEach((key) => objectStore.createIndex(key, key, {unique: false}));
            // one compound index [s,p,o] for each key
            // objectStore.createIndex('compound', this._storeSchemaKeys, {unique: false});
            this._connectDB(cb);
        }
    }

    get(key) {
        return new Promise((resolve, reject) => {
            this._connectDB((db) => {
                let transaction = db.transaction([this._storeName], "readonly");
                let request = transaction.objectStore(this._storeName).get(key);
                transaction.onerror = this.logger;
                request.onerror = this.logger;
                request.onsuccess = () => resolve(request.result ? request.result : undefined)
            });
        });
    }

    getAll() {
        return new Promise((resolve, reject) => {
            this._connectDB((db) => {
                let transaction = db.transaction([this._storeName], "readonly");
                let request = transaction.objectStore(this._storeName).getAll();
                transaction.onerror = this.logger;
                request.onerror = this.logger;
                request.onsuccess = () => {
                    resolve(request.result);
                }
            })
        })
    }

    put(data) {
        return new Promise((resolve, reject) => {
            this._connectDB((db) => {
                let transaction = db.transaction([this._storeName], "readwrite");
                let request = transaction.objectStore(this._storeName).put(data);
                request.onerror = this.logger;
                //request.onsuccess = () => {}
                transaction.oncomplete = () => resolve()
            });
        });
    }

    delete(key) {
        return new Promise((resolve, reject) => {
            this._connectDB((db) => {
                let request = db.transaction([this._storeName], "readwrite").objectStore(this._storeName).delete(key);
                request.onerror = this.logger;
                request.onsuccess = () => resolve();
            })
        });
    }

    clear(){
        return new Promise((resolve, reject) => {
            this._connectDB((db) => {
                // let transaction = db.transaction([this._storeName], "readwrite");
                // let request = transaction.objectStore(this._storeName).clear();
                let request = db.transaction([this._storeName], "readwrite").objectStore(this._storeName).clear();
                request.onerror = this.logger;
                request.onsuccess = () => {
                    resolve();
                }
            })
        });
    }

    count(){
        return new Promise((resolve, reject) => {
            this._connectDB((db) => {
                let transaction = db.transaction([this._storeName]);
                let request = transaction.objectStore(this._storeName).count();
                request.onerror = this.logger;
                transaction.onerror = this.logger;
                request.onsuccess = () => {
                    resolve(request.result);
                }
            })
        });
    }

    logger(e) { super.logger(e) }
}
