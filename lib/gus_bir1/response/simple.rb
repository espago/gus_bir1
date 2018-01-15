# frozen_string_literal: true

module GusBir1
  module Response
    class Simple
      def initialize(value, key)
        @value = value
        @key = key
      end

      def to_s
        @value.to_s
      end

      def to_i
        @value.to_i
      end

      def humanize
        Dictionary.send(@key)[@value.to_sym]
      end
    end
  end
end
