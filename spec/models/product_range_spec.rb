require 'spec_helper'

describe ProductRange do
  it { should validate_presence_of :name }
end
