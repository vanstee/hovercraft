require 'hovercraft/loader'

describe Hovercraft::Loader do
  let(:model)  { stub(name: 'Robot') }
  let(:models) { Array.new(3) { model } }
  let(:params) { models.map { |m| [m, 'robot', 'robots'] } }

  describe '#with_each_model' do
    before { subject.stub(models: models) }

    it 'yields the class, name, and plural name of each model' do
      expect { |b| subject.with_each_model(&b) }.to yield_successive_args(*params)
    end
  end

  describe '#models' do
    it 'is memoized' do
      subject.should_receive(:require_models).once.and_return([])

      2.times { subject.models }
    end
  end
end
