# frozen_string_literal: true

module GusBir1
  module Response
    class FullData
      def initialize(body)
        @body = body
      end

      attr_reader :body

      def to_h
        n = Nokogiri.XML body
        Nori.new.parse(n.xpath('//dane').to_s)['dane']
      end
    end
  end
end
