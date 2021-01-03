# frozen_string_literal: true

RSpec.describe Authcat::Passport::Provider::Params, type: :rack_middleware do
  let(:request) { Rack::MockRequest.new(app) }

  let(:base_app) { ->(env) { [200, {}, ["hello, #{env['authcat.passport']}."]] } }

  let(:key) { :token }
  let(:identifier) { 'user_id' }
  let(:app) { described_class.new(base_app, key: key) }

  it 'login' do
    response = request.get("/?#{key}=#{URI.encode_www_form_component(identifier)}")

    expect(response).to eq('hello, lychee.')
  end
end
