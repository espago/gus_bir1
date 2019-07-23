# frozen_string_literal: true

module GusBir1
  module Report
    class TypeMapper
      InvalidReportType = Class.new(StandardError)
      class << self
        def get_report_type(search_report)
          typ = search_report.type
          silos_id = search_report.silos_id
          method = "type_#{typ.to_s.downcase}"
          return unless typ

          send(method, silos_id)
        end

        def method_missing(method, *_args)
          raise InvalidReportType, "Invalid method-report: #{method}"
        end

        def type_p(_silos_id)
          'PublDaneRaportPrawna'
        end

        def type_lp(_silos_id)
          'PublDaneRaportLokalnaPrawnej'
        end

        def type_lf(_silos_id)
          'PublDaneRaportLokalnaFizycznej'
        end

        def type_f(silos_id)
          case silos_id.to_i
          when 1
            'PublDaneRaportDzialalnoscFizycznejCeidg'
          when 2
            'PublDaneRaportDzialalnoscFizycznejRolnicza'
          when 3
            'PublDaneRaportDzialalnoscFizycznejPozostala'
          when 4
            'PublDaneRaportDzialalnoscFizycznejWKrupgn'
          end
        end
      end
    end
  end
end
