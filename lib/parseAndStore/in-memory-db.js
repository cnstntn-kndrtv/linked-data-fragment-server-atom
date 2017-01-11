let {InterfaceDB} = require('./InterfaceDB.js')

module.exports.InMemoryDB = class InMemoryDB extends InterfaceDB {
    constructor(baseName, storeName, storeSchema) {
        super();
        this._db = new Map();
    }

    put(data) {
        return new Promise((resolve, reject) => {
            this._createCompoundIndex(data)
                .then((id) => {
                    this._db.set(id, data);
                    resolve();
                })
        });
    }

    _createCompoundIndex(data) {
        return new Promise((resolve, reject) => {
            let index = [];
            for (var key in data) {
                if (data.hasOwnProperty(key)) {
                    index.push(data[key]);
                }
            }
            let str = `[${index.toString()}]`;
            resolve(str);
        });
    }

    get(key) {
        return new Promise((resolve, reject) => {
            let keyStr = `[${key.toString()}]`;
            resolve(this._db.get(keyStr) || []);
        });
    }

    getAll() {
        return new Promise((resolve, reject) => {
            let result = [];
            this._db.forEach((val) => result.push(val));
            resolve(result);
        });
    }

    delete(key){
        return new Promise((resolve, reject) => {
            this._db.delete(key);
            resolve(key);
        });
    }

    clear(){
        return new Promise((resolve, reject) => {
            this._db.clear();
            resolve();
        });
    }

    count(){
        return new Promise((resolve, reject) => {
           resolve(this._db.size)
        });
    }

    logger(e) { super.logger(e) }
}
