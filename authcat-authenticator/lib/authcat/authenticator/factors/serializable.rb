# frozen_string_literal: true

# 在这里编写你的代码
module Authcat
  module Authenticator
    module Factors
      module Serializable
        def serializer
          @serializer ||= case @options[:serializer]
                          when Symbol
                            Serializers.resolve(@options[:serializer]).new
                          else
                            NilSerializer
                          end
        end

        def issue(record, **, &)
          serializer.encode(super)
        end

        def identify(value)
          super(serializer.decode(value))
        end
      end
    end
  end
end
