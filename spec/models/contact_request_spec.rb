require 'spec_helper'

describe ContactRequest do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :message }
end
