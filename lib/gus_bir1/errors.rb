# frozen_string_literal: true

module GusBir1
  class Errors
    TooMuchTypesSelected = Class.new(StandardError)
    NoOneTypeSelected = Class.new(StandardError)
  end
end
