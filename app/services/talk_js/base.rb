module TalkJs
  class Base
    include HTTParty

    base_uri "https://api.talkjs.com/v1/#{ENV['TALK_JS_APP_ID']}"

    def self.call(*args, &block)
      new(*args, &block).call
    end

    def get(url)
      self.class.get url, headers: headers
    end

    def put(url, body)
      self.class.put url, body: body.to_json, headers: headers
    end

    def delete(url)
      self.class.delete url, headers: headers
    end

    def post(url, body = {})
      self.class.post url, body: body.to_json, headers: headers
    end

    private

    def headers
      { 'Authorization' => "Bearer #{ENV['TALK_JS_SECRET_KEY']}", 'content-type' => 'application/json' }
    end
  end
end
