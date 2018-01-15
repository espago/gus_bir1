# frozen_string_literal: true

module GusBir1
  module Response
    class Search
      def initialize(body)
        @body = body
      end

      attr_reader :body

      def array
        n = Nokogiri.XML body
        n.xpath('//dane').map { |o| parse_dane(Nori.new.parse(o.to_s)['dane']) }
      end

      private

      def parse_dane(hash)
        search_result            = OpenStruct.new
        search_result.name       = hash['Nazwa']
        search_result.regon      = hash['Regon']
        search_result.province   = hash['Wojewodztwo']
        search_result.district   = hash['Powiat']
        search_result.community  = hash['Gmina']
        search_result.city       = hash['Miejscowosc']
        search_result.zip_code   = hash['KodPocztowy']
        search_result.street     = hash['Ulica']
        search_result.type       = hash['Typ']
        search_result.silos_id   = hash['SilosID']
        search_result.type_desc  = type_info(search_result)
        search_result.silos_desc = silos_info(search_result)
        search_result.report     = report_info(search_result)
        search_result
      end

      def type_info(search_result)
        Dictionary.szukaj_typ[search_result.type.to_sym]
      end

      def silos_info(search_result)
        Dictionary.szukaj_silos_id[search_result.silos_id.to_sym]
      end

      def report_info(search_result)
        Report::TypeMapper.get_report_type(search_result)
      end
    end
  end
end
