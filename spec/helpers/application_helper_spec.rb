require 'spec_helper'

describe ApplicationHelper do
  describe '#nav_class' do
    let(:nav_item) { double(href:'/about-us') }
    context 'when request matches nav item' do
      before { controller.request.path = '/about-us' }

      it 'is active' do
        expect(helper.nav_class(nav_item)).to eq 'active'
      end
    end
    context 'when request does not match nav item' do
      before { controller.request.path = '/contact-us' }

      it 'is nil' do
        expect(helper.nav_class(nav_item)).to be_nil
      end
    end
  end
end
