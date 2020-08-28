import React from 'react';
import { shallow } from 'enzyme';

import Square from './index.js';

describe('<Square />', () => {
  it('render div', () => {
    const wrapper = shallow(<Square />);
    expect(wrapper.find(button)).to.have.lengthOf(1);
  });
});
