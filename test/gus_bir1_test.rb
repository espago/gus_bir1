# frozen_string_literal: true

require 'test_helper'

class GusBir1Test < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::GusBir1::VERSION
  end

  def setup
    GusBir1.production = false
    GusBir1.client_key = 'abcde12345abcde12345'

    @gus_hash = {
      name: 'GŁÓWNY URZĄD STATYSTYCZNY',
      regon: '000331501',
      province: 'MAZOWIECKIE',
      district: 'm. st. Warszawa',
      community: 'Śródmieście',
      city: 'Warszawa',
      zip_code: '00-925',
      street: 'ul. Test-Krucza',
      type: 'P',
      silos_id: '6',
      type_desc: 'Typ jednostki – jednostka prawna',
      silos_desc: 'Miejsce prowadzenia działalności jednostki prawnej',
      report: 'PublDaneRaportPrawna',
      street_number: '208',
      house_number: nil,
      street_address: "ul. Test-Krucza 208"
    }

    @psp_hash = {
      name: '"PSP POLSKA" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ',
      regon: '021215833',
      province: 'DOLNOŚLĄSKIE',
      district: 'm. Wrocław',
      community: 'Wrocław-Stare Miasto',
      city: 'Wrocław',
      zip_code: '53-505',
      street: 'ul. Test-Krucza',
      type: 'P',
      silos_id: '6',
      type_desc: 'Typ jednostki – jednostka prawna',
      silos_desc: 'Miejsce prowadzenia działalności jednostki prawnej',
      report: 'PublDaneRaportPrawna',
      street_number: '15',
      house_number: nil,
      street_address: "ul. Test-Krucza 15"
    }
  end

  def test_service_status
    response = GusBir1.service_status
    assert_equal 1, response.to_i
    assert_equal 'usługa dostępna', response.humanize
  end

  def test_status_date_state
    assert_equal '19-10-2018', GusBir1.status_date_state
  end

  def test_session_status
    response = GusBir1.session_status
    assert_equal '1', response.to_s
    assert_equal 'sesja istnieje', response.humanize
  end

  def test_find_by_regon
    response = GusBir1.find_by(regon: '000331501')

    assert_equal 1, response.size
    assert_equal @gus_hash, response.first.to_h
  end

  def test_find_by_nip
    response = GusBir1.find_by(nip: '8992689516')
    assert_equal 1, response.size
    assert_equal @psp_hash, response.first.to_h
  end

  def test_find_by_krs
    response = GusBir1.find_by(krs: '0000352235')
    assert_equal 1, response.size
    assert_equal @psp_hash, response.first.to_h
  end

  def test_find_by_regons14
    response = GusBir1.find_by(regons14: '00033150100000,02121583300000')
    assert_equal 2, response.size
    assert_equal @gus_hash, response.first.to_h
    assert_equal @psp_hash, response.last.to_h
  end

  def test_find_by_regons9
    response = GusBir1.find_by(regons9: '000331501,021215833')
    assert_equal 2, response.size
    assert_equal @gus_hash, response.first.to_h
    assert_equal @psp_hash, response.last.to_h
  end

  def test_find_by_nips
    response = GusBir1.find_by(nips: '8992689516,5261040828')
    assert_equal 2, response.size
    assert_equal @psp_hash, response.first.to_h
    assert_equal @gus_hash, response.last.to_h
  end

  def test_find_by_krss
    response = GusBir1.find_by(krss: '0000352235')
    assert_equal 1, response.size
    assert_equal @psp_hash, response.last.to_h
  end

  def test_find_and_get_full_data
    response = GusBir1.find_and_get_full_data(nips: '8992689516,5261040828')
    assert_equal 2, response.size
    assert response.first.instance_of? GusBir1::Response::FullData
    assert response.first.respond_to?(:to_h)
    assert response.first.respond_to?(:body)
    assert_equal 'GŁÓWNY URZĄD STATYSTYCZNY', response.last.to_h['praw_nazwa']
  end

  def test_get_full_data
    response = GusBir1.get_full_data('000331501', 'PublDaneRaportPrawna')
    assert response.instance_of? GusBir1::Response::FullData
    assert response.respond_to?(:to_h)
    assert response.respond_to?(:body)
    assert_equal 'GŁÓWNY URZĄD STATYSTYCZNY', response.to_h['praw_nazwa']
  end
end
