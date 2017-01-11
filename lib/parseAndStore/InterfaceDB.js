let {Interface} = require('../utils/Interface.js');

// you must override all methods in child class of this interface 😈
module.exports.InterfaceDB = class InterfaceDB extends Interface {
    put() {}
    get(key) {}
    getAll(){}
    delete(key) {}
    clear(){}
    count(){}
    // has() {}
    // getNext() {}
    // getNextBulk() {}
    logger(err) {
        console.log('DB Error:', err);
    }
}
