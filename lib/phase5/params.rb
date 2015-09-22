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
      @params = Hash.new.merge(route_params)
    end

    def [](key)
      @params[key]
    end

    # this will be useful if we want to `puts params` in the server log
    def to_s
      @params.to_s
    end

    class AttributeNotFoundError < ArgumentError; end;

    # private
    # this should return deeply nested hash
    # argument format
    # user[address][street]=main&user[address][zip]=89436
    # should return
    # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
    def parse_www_encoded_form(www_encoded_form)
      query_array = URI.decode_www_form(www_encoded_form)
      
      query_array.each do |query|
        parsed_key = parse_key(query[0])

        if parsed_key.is_a?(String)
          @params[parsed_key] = query[1]
        else
          index = 0
          while index < parsed_key.length - 1
            if index == parsed_key.length - 2
              @params[parsed_key[index]] = { parsed_key[index + 1] => query.last }
            else
              @params[parsed_key[index]] = { parsed_key[index + 1] => nil }
            end
            index += 1
          end
        end
      end
    end

    # this should return an array
    # user[address][street] should return ['user', 'address', 'street']
    def parse_key(key)
      if key =~ /\[|\]/
        # puts "Key: #{key.split(/\]\[|\[|\]/)}"
        key.split(/\]\[|\[|\]/)
      else
        # puts "Key: #{key}"
        key
      end
    end
  end
end
