// Interface 😈
// can't create instance of Interface directly
// child must implement all parents methods

module.exports.Interface = class Interface {
    constructor () {
        // direct instance error
        if ( new.target === Interface) throw new TypeError("Can't construct instance of Interface directly");
        // childs must override parents methods
        this._child = this.__proto__;
        this._childName = this._child.constructor.name;
        this._childMethods = Object.getOwnPropertyNames(this._child);
        this._parent = this.__proto__.__proto__;
        this._parentName = this._parent.constructor.name;
        this._parentMethods = Object.getOwnPropertyNames(this._parent);
        if (this._parentMethods) {
            this._parentMethods.forEach((method) => {
                if (!this._childMethods.includes(method)) throw new TypeError (`You must override method "${method}" in Class "${this._childName}" extends Interface "${this._parentName}"`);
            });
        }
    }
}
