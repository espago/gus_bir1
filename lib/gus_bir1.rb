# frozen_string_literal: true

require 'gus_bir1/version'
require 'gus_bir1/constants'
require 'gus_bir1/client'
require 'gus_bir1/dictionary'
require 'gus_bir1/response/simple'
require 'gus_bir1/response/search'
require 'gus_bir1/response/full_data'
require 'gus_bir1/report/types'
require 'gus_bir1/report/type_mapper'
require 'gus_bir1/errors'
require 'forwardable'
require 'ostruct'

module GusBir1
  class << self
    extend Forwardable

    def_delegators :client, :production, :client_key, :service_status,
                   :session_status, :status_date_state, :find_by, :find_and_get_full_data,
                   :get_full_data
    def_delegators :client, :production=, :client_key=, :log_level=, :logging=

    def service_available?
      client.service_status.to_i == 1
    end

    private

    def client
      @client ||= GusBir1::Client.new
    end
  end
end
