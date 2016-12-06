'use babel';

import LinkedDataFragmentsAtomView from './linked-data-fragments-atom-view';
import { CompositeDisposable } from 'atom';
import '../server/server';

export default {

  linkedDataFragmentsAtomView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.linkedDataFragmentsAtomView = new LinkedDataFragmentsAtomView(state.linkedDataFragmentsAtomViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.linkedDataFragmentsAtomView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'linked-data-fragments-atom:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.linkedDataFragmentsAtomView.destroy();
  },

  serialize() {
    // To save the current package's state, this method should return
    // an object containing all required data.
    return {
      linkedDataFragmentsAtomViewState: this.linkedDataFragmentsAtomView.serialize()
    };
  },

  getPath() {
      let projectPaths = atom.workspace.getPaths();

  },

  toggle() {
    console.log('LinkedDataFragmentsAtom was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
