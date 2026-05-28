# frozen_string_literal: true

module GusBir1
  class Constants
    WSDL_ADDRESS_TEST = 'https://wyszukiwarkaregontest.stat.gov.pl/wsBIR/wsdl/UslugaBIRzewnPubl-ver11-test.wsdl'
    WSDL_ADDRESS = 'https://wyszukiwarkaregon.stat.gov.pl/wsBIR/wsdl/UslugaBIRzewnPubl-ver11-prod.wsdl'

    WSDL_NS_PUBL = 'http://CIS/BIR/PUBL/2014/07'
    WSDL_NS = 'http://CIS/BIR/2014/07'
    WSDL_NS_DATA_CONTRACT = 'http://CIS/BIR/PUBL/2014/07/DataContract'

    PARAM_USER_KEY = 'pKluczUzytkownika'
    PARAM_SESSION_ID = 'pIdentyfikatorSesji'
    PARAM_CAPTCHA = 'pCaptcha'
    PARAM_SEARCH = 'pParametryWyszukiwania'
    PARAM_REGON = 'pRegon'
    PARAM_REPORT_NAME = 'pNazwaRaportu'
    PARAM_PARAM_NAME = 'pNazwaParametru'
    PARAM_REPORT_DATE = 'pDataRaportu'

    SEARCH_TYPE_NIP  = 'dat:Nip'
    SEARCH_TYPE_KRS  = 'dat:Krs'
    SEARCH_TYPE_REGON = 'dat:Regon'
    SEARCH_TYPE_NIPS  = 'dat:Nipy'
    SEARCH_TYPE_KRSS = 'dat:Krsy'
    SEARCH_TYPE_REGONS_9 = 'dat:Regony9zn'
    SEARCH_TYPE_REGONS_14 = 'dat:Regony14zn'

    PARAM_STATUS_DATE_STATE = 'StanDanych'
    PARAM_MESSAGE_CODE = 'KomunikatKod'
    PARAM_MESSAGE = 'KomunikatTresc'
    PARAM_SESSION_STATUS = 'StatusSesji'
    PARAM_SERVICE_STATUS = 'StatusUslugi'
    PARAM_SERVICE_MESSAGE = 'KomunikatUslugi'

    SERVICE_UNAVAILABLE = 0
    SERVICE_AVAILABLE = 1
    SERVICE_TECHNICAL_BREAK = 2

    NEED_TO_CHECK_CAPTCHA = 1
    TO_FEW_IDENTIFIERS = 2
    NOT_FOUND = 4
    NO_ACCESS_TO_REPORT = 5
    SESSION_ERROR = 7
  end
end
