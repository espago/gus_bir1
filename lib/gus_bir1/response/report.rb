# frozen_string_literal: true

module GusBir1
  module Response
    class Report
      def initialize(body)
        @body = body
      end

      attr_reader :body

      def array
        n = Nokogiri.XML body
        n.xpath('//dane').map { |o| Nori.new.parse(o.to_s)['dane']['regon'] }.compact
      end
    end
  end
end
