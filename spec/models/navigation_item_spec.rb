require 'spec_helper'

describe NavigationItem do
  it 'has soft delete' do
    NavigationItem.create.destroy
    expect(NavigationItem.with_deleted.count).to eq 1
    expect(NavigationItem.with_deleted.first.deleted_at).not_to be_nil
  end
end
