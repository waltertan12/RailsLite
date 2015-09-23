require 'uri'

module Phase5
  class Params
    # use your initialize to merge params from
    # 1. query string
    # 2. post body
    # 3. route params
    #
    # You haven't done routing yet; but assume route params will be
    # passed in as a hash to `Params.new` as below:
    def initialize(req, route_params = {})
      @params = route_params
      @params.merge!(parse_www_encoded_form(req.query_string))
      @params.merge!(parse_www_encoded_form(req.body))
    end

    def [](key)
      JSON.parse(@params.to_json)[key.to_s]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      if www_encoded_form
        hashed = Hash[URI.decode_www_form(www_encoded_form)]
        nest(hashed)
      else
        {}
      end
    end

    def nest(hashed)
      nested = {}

      hashed.each do |key, val|
        all_keys = parse_key(key)
        current = nested

        last_key = all_keys.pop

        all_keys.each do |nested_key|
          current[nested_key] ||= {}
          current = current[nested_key]
        end

        current[last_key] = val
      end

      nested
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      key.split(/\]\[|\[|\]/)
    end
  end
end
