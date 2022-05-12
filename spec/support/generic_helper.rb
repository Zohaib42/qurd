module GenericHelper
  def check_valid?(object, attr, value, error_message)
    object[attr] = value
    expect(object.save).to be_falsey
    expect(object.errors.full_messages).to eq(error_message)
  end

  def dump_rpush
    Rpush::Gcm::App.create(name: QUADIO_APP, auth_key: GCM_API_KEY, connections: 1)

    allow(Rpush).to receive(:push).and_return(nil)
  end
end

RSpec.configure do |config|
  config.include GenericHelper
end
