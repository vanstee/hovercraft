require 'hovercraft/caller'

describe Hovercraft::Caller do
  describe '#directory' do
    before { subject.stub(caller_file: '/gems/futurama/parallel_universe_box.rb:10 in `universe`') }

    it 'returns the directory of the file at the top of the execution stack' do
      subject.directory.should == '/gems/futurama'
    end
  end

  describe '#cleaned_caller_files' do
    let(:files) do
      [
        '/gems/futurama/parallel_universe_box.rb:10 in `universe`',
        '/gems/futurama/parallel_universe_box.rb:3 in `initialize`',
        '<internal: (irb)'
      ]
    end

    before { subject.stub(caller: files) }

    it 'returns a cleaned list of files on the execution stack' do
      subject.cleaned_caller_files.should_not include('<internal: (irb)')
      subject.cleaned_caller_files.should have(2).files
    end
  end
end
