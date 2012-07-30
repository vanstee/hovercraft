require 'hovercraft/helpers'

describe Hovercraft::Helpers do
  subject { Class.new { extend Hovercraft::Helpers } }
  let(:model_to_json) { stub }
  let(:model) { stub(to_json: model_to_json) }

  describe '.registered' do
    let(:application) { stub }

    it 'includes the helpers in the application' do
      application.should_receive(:helpers).with(described_class)

      Hovercraft::Helpers.registered(application)
    end
  end

  describe '#authenticate_with_warden' do
    let(:warden) { stub(authenticate!: nil) }

    before { subject.stub(warden: warden) }

    it 'uses warden to authenticate' do
      warden.should_receive(:authenticate!)

      subject.authenticate_with_warden
    end
  end

  describe '#warden' do
    let(:warden) { stub }
    let(:env) { stub }

    before { subject.stub(env: env) }

    it 'finds the warden instance in the current session' do
      env.stub(:fetch).with('warden') { warden }

      subject.warden
    end
  end

  describe '#respond_with' do
    it 'serializes the content to the preferred format' do
      subject.stub(format: :json)

      subject.respond_with(model).should == model_to_json
    end

    it 'fails if the preferred format is not supported' do
      subject.stub(format: :xml)

      lambda { subject.respond_with(model) }.should raise_error
    end
  end

  describe '#format' do
    let(:format_param)   { stub }
    let(:preferred_type) { stub }
    let(:default_format) { stub }

    before do
      subject.stub(
        params: { format: nil },
        preferred_type: nil,
        default_format: nil
      )
    end

    it 'defaults to the format param' do
      subject.stub(params: { format: format_param })
      subject.format.should == format_param
    end

    it 'falls back on the preferred_type' do
      subject.stub(preferred_type: preferred_type)
      subject.format.should == preferred_type
    end

    it 'uses the default format as a worst case' do
      subject.stub(default_format: default_format)
      subject.format.should == default_format
    end
  end

  describe '#preferred_type' do
    let(:default_format) { stub }

    before { subject.stub(default_format: default_format) }

    it 'checks for json' do
      subject.stub_chain(:request, :preferred_type) { 'application/json' }
      subject.preferred_type.should == :json
    end

    it 'checks for xml' do
      subject.stub_chain(:request, :preferred_type) { 'application/xml' }
      subject.preferred_type.should == :xml
    end

    it 'defaults to json if any format is allowed' do
      subject.stub_chain(:request, :preferred_type) { '*/*' }
      subject.preferred_type.should == default_format
    end

    it 'fails if the acceptable type is unknown' do
      subject.stub_chain(:request, :preferred_type) { 'unknown/type' }
      lambda { subject.preferred_type.should }.should raise_error
    end
  end
end
