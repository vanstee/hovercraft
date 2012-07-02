require 'hovercraft/server'

describe Hovercraft::Server do
  it 'is a rack application' do
    subject.respond_to?(:call).should be_true
  end
end
