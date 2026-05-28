# frozen_string_literal: true

module GusBir1
  module Response

    class List
      def initialize(body)
        @body = body
      end

      attr_reader :body

      def array
        n = Nokogiri.XML body
        n.xpath('//dane/regon/text()').map { |o| o.to_s }
      end

      private

    end
  end
end
