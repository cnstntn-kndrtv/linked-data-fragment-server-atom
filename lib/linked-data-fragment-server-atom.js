'use babel';

import LinkedDataFragmentServerAtomView from './linked-data-fragment-server-atom-view';
import { CompositeDisposable } from 'atom';

export default {

  linkedDataFragmentServerAtomView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.linkedDataFragmentServerAtomView = new LinkedDataFragmentServerAtomView(state.linkedDataFragmentServerAtomViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.linkedDataFragmentServerAtomView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'linked-data-fragment-server-atom:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.linkedDataFragmentServerAtomView.destroy();
  },

  serialize() {
    return {
      linkedDataFragmentServerAtomViewState: this.linkedDataFragmentServerAtomView.serialize()
    };
  },

  toggle() {
    console.log('LinkedDataFragmentServerAtom was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
