# frozen_string_literal: true

module GusBir1
  class Client
    SESSION_TIMEOUT = 3600
    attr_accessor :production, :client_key, :log_level, :logging

    def service_status
      v = get_value(Constants::PARAM_PARAM_NAME => Constants::PARAM_SERVICE_STATUS)
      Response::Simple.new(v, Constants::PARAM_SERVICE_STATUS)
    end

    def session_status
      set_session_id
      v = get_value(Constants::PARAM_PARAM_NAME => Constants::PARAM_SESSION_STATUS)
      Response::Simple.new(v, Constants::PARAM_SESSION_STATUS)
    end

    def status_date_state
      set_session_id
      get_value(Constants::PARAM_PARAM_NAME => Constants::PARAM_STATUS_DATE_STATE)
    end

    def find_by(nip: nil, regon: nil, krs: nil, nips: nil, krss: nil, regons14: nil, regons9: nil)
      types = [nip, regon, krs, nips, krss, regons14, regons9].compact
      raise TooMuchTypesSelected if types.size > 1
      raise NoOneTypeSelected if types.empty?
      if nip
        search_by Constants::SEARCH_TYPE_NIP, nip
      elsif regon
        search_by Constants::SEARCH_TYPE_REGON, regon
      elsif krs
        search_by Constants::SEARCH_TYPE_KRS, krs
      elsif nips
        search_by Constants::SEARCH_TYPE_NIPS, nips
      elsif regons9
        search_by Constants::SEARCH_TYPE_REGONS_9, regons9
      elsif regons14
        search_by Constants::SEARCH_TYPE_REGONS_14, regons14
      elsif krss
        search_by Constants::SEARCH_TYPE_KRSS, krss
      end
    end

    def get_full_data(regon, report = 'BIR11OsPrawna')
      set_session_id
      Response::FullData.new dane_pobierz_pelny_raport(
        Constants::PARAM_REGON => regon,
        Constants::PARAM_REPORT_NAME => report
      )
    end

    def get_full_data_from_response(hash)
      get_full_data(
        hash.regon,
        Report::TypeMapper.get_report_type(hash)
      )
    end

    def find_and_get_full_data(hash)
      r = find_by(hash)
      r.map { |h| get_full_data_from_response(h) }
    end

    private

    def search_by(search_by, search)
      set_session_id
      Response::Search.new(
        dane_szukaj_podmioty(Constants::PARAM_SEARCH => { search_by => search })
      ).array
    end

    def namespaces(publ: true)
      {
        'xmlns:ns' =>  publ ? Constants::WSDL_NS_PUBL : Constants::WSDL_NS,
        'xmlns:dat' => Constants::WSDL_NS_DATA_CONTRACT
      }
    end

    def endpoint
      return Constants::WSDL_ADDRESS if @production
      Constants::WSDL_ADDRESS_TEST
    end

    def method_missing(method, *args)
      if savon_client.operations.include? method
        response_body = call(method, args[0]).body
        response_body.dig("#{method}_response".to_sym, "#{method}_result".to_sym)
      else
        super
      end
    end

    def call(method, message)
      case method
      when
          :wyloguj,
          :dane_szukaj_podmioty,
          :dane_pobierz_pelny_raport,
          :dane_komunikat,
          :zaloguj
        savon_client_publ.call(method, message: message)
      else
        savon_client.call(method, message: message)
      end
    end

    def set_session_id
      return @sid if sid_active
      @sid_exp = Time.now + SESSION_TIMEOUT
      @sid = zaloguj(Constants::PARAM_USER_KEY => @client_key)
      clear_savon_clients
    end

    def sid_active
      @sid && Time.now < @sid_exp
    end

    def clear_session
      logout if sid_active
      @sid = nil
      @sid_exp = nil
      clear_savon_clients
    end

    def logout
      return unless sid_active
      wyloguj(Constants::PARAM_SESSION_ID => @sid)
    end

    def savon_client_publ
      @savon_client_publ ||= Savon.client(savon_options(publ: true))
    end

    def savon_client
      @savon_client ||= Savon.client(savon_options)
    end

    def savon_options(publ: false)
      params = {
        wsdl: endpoint,
        namespaces: namespaces(publ: publ),
        env_namespace: :soap,
        use_wsa_headers: true,
        soap_version: 2,
        namespace_identifier: :ns,
        element_form_default: :qualified,
        multipart: true,
        log_level: @log_level,
        log: @logging,
        proxy: ENV['GUS_BIR_PROXY_URL']
      }
      if defined?(@sid) && @sid.nil? == false
        params.merge!({headers: { sid: @sid } })
      end
      params
    end

    def clear_savon_clients
      @savon_client = nil
      @savon_client_publ = nil
    end

    def savon_api_client
      @savon_api_client ||= GusBir1::SavonApiClient.new
    end
  end
end
require 'savon'
require 'savon-multipart'
