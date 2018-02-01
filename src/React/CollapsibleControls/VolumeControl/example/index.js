import 'normalize.css';

import React from 'react';
import ReactDOM from 'react-dom';

import EqualizerState from '../../../../Common/State/EqualizerState';
import LookupTableManager from '../../../../Common/Core/LookupTableManager';

import ToggleState from '../../../../Common/State/ToggleState';
import VolumeControl from '..';

const computation = new ToggleState();
const intensity = new ToggleState();
const equalizer = new EqualizerState({ size: 26 });
const lookupTableManager = new LookupTableManager();
const lookupTable = {
  originalRange: [-5, 15],
  lookupTableManager,
  lookupTable: lookupTableManager.addLookupTable('demo', [-5, 15], 'spectral'),
};
const container = document.querySelector('.content');

ReactDOM.render(
  React.createElement(VolumeControl, {
    computation,
    equalizer,
    intensity,
    lookupTable,
  }),
  container
);

document.body.style.margin = '10px';
