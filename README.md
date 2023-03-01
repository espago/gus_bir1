# GusBir1
[![license](https://img.shields.io/badge/License-MIT-purple.svg)](LICENSE)
[![CI badge](https://github.com/espago/gus_bir1/actions/workflows/ci.yml/badge.svg)](https://github.com/espago/gus_bir1/actions/workflows/ci.yml/badge.svg)
[![Gem Version](https://badge.fury.io/rb/gus_bir1.svg)](https://badge.fury.io/rb/gus_bir1)
[![Code Climate](https://codeclimate.com/github/espago/gus_bir1/badges/gpa.svg)](https://codeclimate.com/github/espago/gus_bir1)
[![Test Coverage](https://codeclimate.com/github/espago/gus_bir1/badges/coverage.svg)](https://codeclimate.com/github/espago/gus_bir1)

Simple, Ruby wrapper for REGON database (Baza Internetowa Regon (BIR))(web frontend is reachable at https://wyszukiwarkaregon.stat.gov.pl/appBIR/index.aspx). To access its SOAP API, one needs a USER_KEY issued by REGON administrators available at regon_bir@stat.gov.pl.

Official GUS docs: https://api.stat.gov.pl/Home/RegonApi


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'gus_bir1'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gus_bir1

## Usage

### Settings

```ruby
# /config/initializers/gus_bir1.rb
# TEST CONF
GusBir1.production = false
GusBir1.client_key = 'abcde12345abcde12345'
```

### General info

#### To check service status:

```ruby
GusBir1.service_status.to_i
 => 1
GusBir1.service_status.humanize
 => "usługa dostępna"
 ```

#### To check data status
```ruby
GusBir1.status_date_state
=> "18-05-2016"
```

#### To get session status
```ruby
GusBir1.session_status.to_i
 => 1
GusBir1.session_status.humanize
 => "sesja istnieje"
```

### Get data
To start querying the GUS database, You can use three methods `GusBir1.find_by`, `GusBir1.get_full_data` and (the best option) - `GusBir1.find_and_get_full_data` with one of the following parameters:
* regon - single REGON number (either 9 or 14 digits long)
* krs - single 10 digit KRS number
* nip - single NIP (10 digits string)
* regons14 - a collection of REGONs 14 digits long
* regons9 - a collection of REGONs 9 digits long
* krss - a collection of KRSs
* nips - a collection of NIPs

#### find_by
with `regon`
```ruby
response = GusBir1.find_by(regon: '00033150100000')
 => [#<OpenStruct name="GŁÓWNY URZĄD STATYSTYCZNY", regon="00033150100000", province="MAZOWIECKIE", district="m. st. Warszawa", community="Śródmieście", city="Warszawa", zip_code="00-925", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
response.class
 => Array
response.first
 => #<OpenStruct name="GŁÓWNY URZĄD STATYSTYCZNY", regon="00033150100000", province="MAZOWIECKIE", district="m. st. Warszawa", community="Śródmieście", city="Warszawa", zip_code="00-925", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">
```

with `nip`
```ruby
response = GusBir1.find_by(nip: '8992689516')
 => [#<OpenStruct name="\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", regon="02121583300000", province="DOLNOŚLĄSKIE", district="m. Wrocław", community="Wrocław-Stare Miasto", city="Wrocław", zip_code="53-505", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
 ```

with `krs`
```ruby
response = GusBir1.find_by(krs: '0000352235')
 => [#<OpenStruct name="\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", regon="02121583300000", province="DOLNOŚLĄSKIE", district="m. Wrocław", community="Wrocław-Stare Miasto", city="Wrocław", zip_code="53-505", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
```

with `regons14` (up to 20 regons)
```ruby
response = GusBir1.find_by(regons14: '00033150100000,02121583300000')
 => [#<OpenStruct name="GŁÓWNY URZĄD STATYSTYCZNY", regon="00033150100000", province="MAZOWIECKIE", district="m. st. Warszawa", community="Śródmieście", city="Warszawa", zip_code="00-925", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">, #<OpenStruct name="\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", regon="02121583300000", province="DOLNOŚLĄSKIE", district="m. Wrocław", community="Wrocław-Stare Miasto", city="Wrocław", zip_code="53-505", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
 ```

 with `regons9` (up to 20 regons)
 ```ruby
 response = GusBir1.find_by(regons9: '000331501,021215833')
 => [#<OpenStruct name="GŁÓWNY URZĄD STATYSTYCZNY", regon="00033150100000", province="MAZOWIECKIE", district="m. st. Warszawa", community="Śródmieście", city="Warszawa", zip_code="00-925", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">, #<OpenStruct name="\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", regon="02121583300000", province="DOLNOŚLĄSKIE", district="m. Wrocław", community="Wrocław-Stare Miasto", city="Wrocław", zip_code="53-505", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
  ```

with `nips` (up to 20 nips)
```ruby
 response = GusBir1.find_by(nips: '8992689516,5261040828')
 => [#<OpenStruct name="GŁÓWNY URZĄD STATYSTYCZNY", regon="00033150100000", province="MAZOWIECKIE", district="m. st. Warszawa", community="Śródmieście", city="Warszawa", zip_code="00-925", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">, #<OpenStruct name="\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", regon="02121583300000", province="DOLNOŚLĄSKIE", district="m. Wrocław", community="Wrocław-Stare Miasto", city="Wrocław", zip_code="53-505", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
```

with `krss` (up to 20 krss)
```ruby
response = GusBir1.find_by(krss: '0000352235')
 => [#<OpenStruct name="\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ", regon="02121583300000", province="DOLNOŚLĄSKIE", district="m. Wrocław", community="Wrocław-Stare Miasto", city="Wrocław", zip_code="53-505", street="ul. Test-Krucza", type="P", silos_id="6", type_desc="Typ jednostki – jednostka prawna", silos_desc="Miejsce prowadzenia działalności jednostki prawnej", report="PublDaneRaportPrawna">]
```

#### get_full_data

If one knows the REGON of a business entity and an detailed report name, a full report can be fetched directly:
```ruby
response = GusBir1.get_full_data('000331501', 'PublDaneRaportPrawna')
 => #<GusBir1::Response::FullData:0x00007f9c180a52d8 @body="<root>\r\n  <dane>\r\n    <praw_regon14>00033150100000</praw_regon14>\r\n    <praw_nip>5261040828</praw_nip>\r\n    <praw_nazwa>GŁÓWNY URZĄD STATYSTYCZNY</praw_nazwa>\r\n    <praw_nazwaSkrocona>GUS</praw_nazwaSkrocona>\r\n    <praw_numerWrejestrzeEwidencji />\r\n    <praw_dataPowstania>1975-12-15</praw_dataPowstania>\r\n    <praw_dataRozpoczeciaDzialalnosci>1975-12-15</praw_dataRozpoczeciaDzialalnosci>\r\n    <praw_dataWpisuDoREGON />\r\n    <praw_dataZawieszeniaDzialalnosci />\r\n    <praw_dataWznowieniaDzialalnosci />\r\n    <praw_dataZaistnieniaZmiany>2009-02-20</praw_dataZaistnieniaZmiany>\r\n    <praw_dataZakonczeniaDzialalnosci />\r\n    <praw_dataSkresleniazRegon />\r\n    <praw_adSiedzKraj_Symbol>PL</praw_adSiedzKraj_Symbol>\r\n    <praw_adSiedzWojewodztwo_Symbol>14</praw_adSiedzWojewodztwo_Symbol>\r\n    <praw_adSiedzPowiat_Symbol>65</praw_adSiedzPowiat_Symbol>\r\n    <praw_adSiedzGmina_Symbol>108</praw_adSiedzGmina_Symbol>\r\n    <praw_adSiedzKodPocztowy>00925</praw_adSiedzKodPocztowy>\r\n    <praw_adSiedzMiejscowoscPoczty_Symbol>0919810</praw_adSiedzMiejscowoscPoczty_Symbol>\r\n    <praw_adSiedzMiejscowosc_Symbol>0919810</praw_adSiedzMiejscowosc_Symbol>\r\n    <praw_adSiedzUlica_Symbol>10013</praw_adSiedzUlica_Symbol>\r\n    <praw_adSiedzNumerNieruchomosci>208</praw_adSiedzNumerNieruchomosci>\r\n    <praw_adSiedzNumerLokalu />\r\n    <praw_adSiedzNietypoweMiejsceLokalizacji />\r\n    <praw_numerTelefonu>6083000</praw_numerTelefonu>\r\n    <praw_numerWewnetrznyTelefonu />\r\n    <praw_numerFaksu>0226083863</praw_numerFaksu>\r\n    <praw_adresEmail>dgsek@stat.gov.pl</praw_adresEmail>\r\n    <praw_adresStronyinternetowej>www.stat.gov.pl</praw_adresStronyinternetowej>\r\n    <praw_adresEmail2 />\r\n    <praw_adKorKraj_Symbol>PL</praw_adKorKraj_Symbol>\r\n    <praw_adKorWojewodztwo_Symbol>14</praw_adKorWojewodztwo_Symbol>\r\n    <praw_adKorPowiat_Symbol>65</praw_adKorPowiat_Symbol>\r\n    <praw_adKorGmina_Symbol>108</praw_adKorGmina_Symbol>\r\n    <praw_adKorKodPocztowy>00925</praw_adKorKodPocztowy>\r\n    <praw_adKorMiejscowoscPoczty_Symbol>0919810</praw_adKorMiejscowoscPoczty_Symbol>\r\n    <praw_adKorMiejscowosc_Symbol>0919810</praw_adKorMiejscowosc_Symbol>\r\n    <praw_adKorUlica_Symbol>14199</praw_adKorUlica_Symbol>\r\n    <praw_adKorNumerNieruchomosci>208</praw_adKorNumerNieruchomosci>\r\n    <praw_adKorNumerLokalu />\r\n    <praw_adKorNietypoweMiejsceLokalizacji />\r\n    <praw_adKorNazwaPodmiotuDoKorespondencji />\r\n    <praw_adSiedzKraj_Nazwa>POLSKA</praw_adSiedzKraj_Nazwa>\r\n    <praw_adSiedzWojewodztwo_Nazwa>MAZOWIECKIE</praw_adSiedzWojewodztwo_Nazwa>\r\n    <praw_adSiedzPowiat_Nazwa>m. st. Warszawa</praw_adSiedzPowiat_Nazwa>\r\n    <praw_adSiedzGmina_Nazwa>Śródmieście</praw_adSiedzGmina_Nazwa>\r\n    <praw_adSiedzMiejscowosc_Nazwa>Warszawa</praw_adSiedzMiejscowosc_Nazwa>\r\n    <praw_adSiedzMiejscowoscPoczty_Nazwa>Warszawa</praw_adSiedzMiejscowoscPoczty_Nazwa>\r\n    <praw_adSiedzUlica_Nazwa>ul. Test-Krucza</praw_adSiedzUlica_Nazwa>\r\n    <praw_adKorKraj_Nazwa />\r\n    <praw_adKorWojewodztwo_Nazwa />\r\n    <praw_adKorPowiat_Nazwa />\r\n    <praw_adKorGmina_Nazwa />\r\n    <praw_adKorMiejscowosc_Nazwa />\r\n    <praw_adKorMiejscowoscPoczty_Nazwa />\r\n    <praw_adKorUlica_Nazwa />\r\n    <praw_podstawowaFormaPrawna_Symbol>2</praw_podstawowaFormaPrawna_Symbol>\r\n    <praw_szczegolnaFormaPrawna_Symbol>01</praw_szczegolnaFormaPrawna_Symbol>\r\n    <praw_formaFinansowania_Symbol>2</praw_formaFinansowania_Symbol>\r\n    <praw_formaWlasnosci_Symbol>111</praw_formaWlasnosci_Symbol>\r\n    <praw_organZalozycielski_Symbol>050000000</praw_organZalozycielski_Symbol>\r\n    <praw_organRejestrowy_Symbol />\r\n    <praw_rodzajRejestruEwidencji_Symbol>000</praw_rodzajRejestruEwidencji_Symbol>\r\n    <praw_podstawowaFormaPrawna_Nazwa>JEDNOSTKA ORGANIZACYJNA NIEMAJĄCA OSOBOWOŚCI PRAWNEJ</praw_podstawowaFormaPrawna_Nazwa>\r\n    <praw_szczegolnaFormaPrawna_Nazwa>ORGANY WŁADZY,ADMINISTRACJI RZĄDOWEJ</praw_szczegolnaFormaPrawna_Nazwa>\r\n    <praw_formaFinansowania_Nazwa>JEDNOSTKA BUDŻETOWA</praw_formaFinansowania_Nazwa>\r\n    <praw_formaWlasnosci_Nazwa>WŁASNOŚĆ SKARBU PAŃSTWA</praw_formaWlasnosci_Nazwa>\r\n    <praw_organZalozycielski_Nazwa>PREZES GŁÓWNEGO URZĘDU STATYSTYCZNEGO</praw_organZalozycielski_Nazwa>\r\n    <praw_organRejestrowy_Nazwa />\r\n    <praw_rodzajRejestruEwidencji_Nazwa>PODMIOTY UTWORZONE Z MOCY USTAWY</praw_rodzajRejestruEwidencji_Nazwa>\r\n    <praw_jednostekLokalnych>0</praw_jednostekLokalnych>\r\n  </dane>\r\n</root>">
 ```

#### find_and_get_full_data
 ```ruby
 response = GusBir1.find_and_get_full_data(nips: '8992689516,5261040828')
 => [#<GusBir1::Response::FullData:0x00007f9c19087ae8 @body="<root>\r\n  <dane>\r\n    <praw_regon14>00033150100000</praw_regon14>\r\n    <praw_nip>5261040828</praw_nip>\r\n    <praw_nazwa>GŁÓWNY URZĄD STATYSTYCZNY</praw_nazwa>\r\n    <praw_nazwaSkrocona>GUS</praw_nazwaSkrocona>\r\n    <praw_numerWrejestrzeEwidencji />\r\n    <praw_dataPowstania>1975-12-15</praw_dataPowstania>\r\n    <praw_dataRozpoczeciaDzialalnosci>1975-12-15</praw_dataRozpoczeciaDzialalnosci>\r\n    <praw_dataWpisuDoREGON />\r\n    <praw_dataZawieszeniaDzialalnosci />\r\n    <praw_dataWznowieniaDzialalnosci />\r\n    <praw_dataZaistnieniaZmiany>2009-02-20</praw_dataZaistnieniaZmiany>\r\n    <praw_dataZxaaakonczeniaDzialalnosci />\r\n    <praw_dataSkresleniazRegon />\r\n    <praw_adSiedzKraj_Symbol>PL</praw_adSiedzKraj_Symbol>\r\n    <praw_adSiedzWojewodztwo_Symbol>14</praw_adSiedzWojewodztwo_Symbol>\r\n    <praw_adSiedzPowiat_Symbol>65</praw_adSiedzPowiat_Symbol>\r\n    <praw_adSiedzGmina_Symbol>108</praw_adSiedzGmina_Symbol>\r\n    <praw_adSiedzKodPocztowy>00925</praw_adSiedzKodPocztowy>\r\n    <praw_adSiedzMiejscowoscPoczty_Symbol>0919810</praw_adSiedzMiejscowoscPoczty_Symbol>\r\n    <praw_adSiedzMiejscowosc_Symbol>0919810</praw_adSiedzMiejscowosc_Symbol>\r\n    <praw_adSiedzUlica_Symbol>10013</praw_adSiedzUlica_Symbol>\r\n    <praw_adSiedzNumerNieruchomosci>208</praw_adSiedzNumerNieruchomosci>\r\n    <praw_adSiedzNumerLokalu />\r\n    <praw_adSiedzNietypoweMiejsceLokalizacji />\r\n    <praw_numerTelefonu>6083000</praw_numerTelefonu>\r\n    <praw_numerWewnetrznyTelefonu />\r\n    <praw_numerFaksu>0226083863</praw_numerFaksu>\r\n    <praw_adresEmail>dgsek@stat.gov.pl</praw_adresEmail>\r\n    <praw_adresStronyinternetowej>www.stat.gov.pl</praw_adresStronyinternetowej>\r\n    <praw_adresEmail2 />\r\n    <praw_adKorKraj_Symbol>PL</praw_adKorKraj_Symbol>\r\n    <praw_adKorWojewodztwo_Symbol>14</praw_adKorWojewodztwo_Symbol>\r\n    <praw_adKorPowiat_Symbol>65</praw_adKorPowiat_Symbol>\r\n    <praw_adKorGmina_Symbol>108</praw_adKorGmina_Symbol>\r\n    <praw_adKorKodPocztowy>00925</praw_adKorKodPocztowy>\r\n    <praw_adKorMiejscowoscPoczty_Symbol>0919810</praw_adKorMiejscowoscPoczty_Symbol>\r\n    <praw_adKorMiejscowosc_Symbol>0919810</praw_adKorMiejscowosc_Symbol>\r\n    <praw_adKorUlica_Symbol>14199</praw_adKorUlica_Symbol>\r\n    <praw_adKorNumerNieruchomosci>208</praw_adKorNumerNieruchomosci>\r\n    <praw_adKorNumerLokalu />\r\n    <praw_adKorNietypoweMiejsceLokalizacji />\r\n    <praw_adKorNazwaPodmiotuDoKorespondencji />\r\n    <praw_adSiedzKraj_Nazwa>POLSKA</praw_adSiedzKraj_Nazwa>\r\n    <praw_adSiedzWojewodztwo_Nazwa>MAZOWIECKIE</praw_adSiedzWojewodztwo_Nazwa>\r\n    <praw_adSiedzPowiat_Nazwa>m. st. Warszawa</praw_adSiedzPowiat_Nazwa>\r\n    <praw_adSiedzGmina_Nazwa>Śródmieście</praw_adSiedzGmina_Nazwa>\r\n    <praw_adSiedzMiejscowosc_Nazwa>Warszawa</praw_adSiedzMiejscowosc_Nazwa>\r\n    <praw_adSiedzMiejscowoscPoczty_Nazwa>Warszawa</praw_adSiedzMiejscowoscPoczty_Nazwa>\r\n    <praw_adSiedzUlica_Nazwa>ul. Test-Krucza</praw_adSiedzUlica_Nazwa>\r\n    <praw_adKorKraj_Nazwa />\r\n    <praw_adKorWojewodztwo_Nazwa />\r\n    <praw_adKorPowiat_Nazwa />\r\n    <praw_adKorGmina_Nazwa />\r\n    <praw_adKorMiejscowosc_Nazwa />\r\n    <praw_adKorMiejscowoscPoczty_Nazwa />\r\n    <praw_adKorUlica_Nazwa />\r\n    <praw_podstawowaFormaPrawna_Symbol>2</praw_podstawowaFormaPrawna_Symbol>\r\n    <praw_szczegolnaFormaPrawna_Symbol>01</praw_szczegolnaFormaPrawna_Symbol>\r\n    <praw_formaFinansowania_Symbol>2</praw_formaFinansowania_Symbol>\r\n    <praw_formaWlasnosci_Symbol>111</praw_formaWlasnosci_Symbol>\r\n    <praw_organZalozycielski_Symbol>050000000</praw_organZalozycielski_Symbol>\r\n    <praw_organRejestrowy_Symbol />\r\n    <praw_rodzajRejestruEwidencji_Symbol>000</praw_rodzajRejestruEwidencji_Symbol>\r\n    <praw_podstawowaFormaPrawna_Nazwa>JEDNOSTKA ORGANIZACYJNA NIEMAJĄCA OSOBOWOŚCI PRAWNEJ</praw_podstawowaFormaPrawna_Nazwa>\r\n    <praw_szczegolnaFormaPrawna_Nazwa>ORGANY WŁADZY,ADMINISTRACJI RZĄDOWEJ</praw_szczegolnaFormaPrawna_Nazwa>\r\n    <praw_formaFinansowania_Nazwa>JEDNOSTKA BUDŻETOWA</praw_formaFinansowania_Nazwa>\r\n    <praw_formaWlasnosci_Nazwa>WŁASNOŚĆ SKARBU PAŃSTWA</praw_formaWlasnosci_Nazwa>\r\n    <praw_organZalozycielski_Nazwa>PREZES GŁÓWNEGO URZĘDU STATYSTYCZNEGO</praw_organZalozycielski_Nazwa>\r\n    <praw_organRejestrowy_Nazwa />\r\n    <praw_rodzajRejestruEwidencji_Nazwa>PODMIOTY UTWORZONE Z MOCY USTAWY</praw_rodzajRejestruEwidencji_Nazwa>\r\n    <praw_jednostekLokalnych>0</praw_jednostekLokalnych>\r\n  </dane>\r\n</root>">, #<GusBir1::Response::FullData:0x00007f9c1833c708 @body="<root>\r\n  <dane>\r\n    <praw_regon14>02121583300000</praw_regon14>\r\n    <praw_nip>8992689516</praw_nip>\r\n    <praw_nazwa>\"PSP POLSKA\" SPÓŁKA Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ</praw_nazwa>\r\n    <praw_nazwaSkrocona>PSP POLSKA SP. Z O.O.,WROCŁAW</praw_nazwaSkrocona>\r\n    <praw_numerWrejestrzeEwidencji>0000352235</praw_numerWrejestrzeEwidencji>\r\n    <praw_dataPowstania>2010-03-24</praw_dataPowstania>\r\n    <praw_dataRozpoczeciaDzialalnosci>2010-03-24</praw_dataRozpoczeciaDzialalnosci>\r\n    <praw_dataWpisuDoREGON>2010-04-01</praw_dataWpisuDoREGON>\r\n    <praw_dataZawieszeniaDzialalnosci />\r\n    <praw_dataWznowieniaDzialalnosci />\r\n    <praw_dataZaistnieniaZmiany>2010-12-15</praw_dataZaistnieniaZmiany>\r\n    <praw_dataZakonczeniaDzialalnosci />\r\n    <praw_dataSkresleniazRegon />\r\n    <praw_adSiedzKraj_Symbol>PL</praw_adSiedzKraj_Symbol>\r\n    <praw_adSiedzWojewodztwo_Symbol>02</praw_adSiedzWojewodztwo_Symbol>\r\n    <praw_adSiedzPowiat_Symbol>64</praw_adSiedzPowiat_Symbol>\r\n    <praw_adSiedzGmina_Symbol>059</praw_adSiedzGmina_Symbol>\r\n    <praw_adSiedzKodPocztowy>53505</praw_adSiedzKodPocztowy>\r\n    <praw_adSiedzMiejscowoscPoczty_Symbol>0986946</praw_adSiedzMiejscowoscPoczty_Symbol>\r\n    <praw_adSiedzMiejscowosc_Symbol>0986946</praw_adSiedzMiejscowosc_Symbol>\r\n    <praw_adSiedzUlica_Symbol>10013</praw_adSiedzUlica_Symbol>\r\n    <praw_adSiedzNumerNieruchomosci>15</praw_adSiedzNumerNieruchomosci>\r\n    <praw_adSiedzNumerLokalu />\r\n    <praw_adSiedzNietypoweMiejsceLokalizacji />\r\n    <praw_numerTelefonu>791834782</praw_numerTelefonu>\r\n    <praw_numerWewnetrznyTelefonu />\r\n    <praw_numerFaksu>717351551</praw_numerFaksu>\r\n    <praw_adresEmail>psp.polska@gmail.com</praw_adresEmail>\r\n    <praw_adresStronyinternetowej />\r\n    <praw_adresEmail2 />\r\n    <praw_adKorKraj_Symbol>PL</praw_adKorKraj_Symbol>\r\n    <praw_adKorWojewodztwo_Symbol>02</praw_adKorWojewodztwo_Symbol>\r\n    <praw_adKorPowiat_Symbol>64</praw_adKorPowiat_Symbol>\r\n    <praw_adKorGmina_Symbol>059</praw_adKorGmina_Symbol>\r\n    <praw_adKorKodPocztowy>53505</praw_adKorKodPocztowy>\r\n    <praw_adKorMiejscowoscPoczty_Symbol>0986946</praw_adKorMiejscowoscPoczty_Symbol>\r\n    <praw_adKorMiejscowosc_Symbol>0986946</praw_adKorMiejscowosc_Symbol>\r\n    <praw_adKorUlica_Symbol>10793</praw_adKorUlica_Symbol>\r\n    <praw_adKorNumerNieruchomosci>15</praw_adKorNumerNieruchomosci>\r\n    <praw_adKorNumerLokalu />\r\n    <praw_adKorNietypoweMiejsceLokalizacji />\r\n    <praw_adKorNazwaPodmiotuDoKorespondencji />\r\n    <praw_adSiedzKraj_Nazwa>POLSKA</praw_adSiedzKraj_Nazwa>\r\n    <praw_adSiedzWojewodztwo_Nazwa>DOLNOŚLĄSKIE</praw_adSiedzWojewodztwo_Nazwa>\r\n    <praw_adSiedzPowiat_Nazwa>m. Wrocław</praw_adSiedzPowiat_Nazwa>\r\n    <praw_adSiedzGmina_Nazwa>Wrocław-Stare Miasto</praw_adSiedzGmina_Nazwa>\r\n    <praw_adSiedzMiejscowosc_Nazwa>Wrocław</praw_adSiedzMiejscowosc_Nazwa>\r\n    <praw_adSiedzMiejscowoscPoczty_Nazwa>Wrocław</praw_adSiedzMiejscowoscPoczty_Nazwa>\r\n    <praw_adSiedzUlica_Nazwa>ul. Test-Krucza</praw_adSiedzUlica_Nazwa>\r\n    <praw_adKorKraj_Nazwa />\r\n    <praw_adKorWojewodztwo_Nazwa />\r\n    <praw_adKorPowiat_Nazwa />\r\n    <praw_adKorGmina_Nazwa />\r\n    <praw_adKorMiejscowosc_Nazwa />\r\n    <praw_adKorMiejscowoscPoczty_Nazwa />\r\n    <praw_adKorUlica_Nazwa />\r\n    <praw_podstawowaFormaPrawna_Symbol>1</praw_podstawowaFormaPrawna_Symbol>\r\n    <praw_szczegolnaFormaPrawna_Symbol>17</praw_szczegolnaFormaPrawna_Symbol>\r\n    <praw_formaFinansowania_Symbol>1</praw_formaFinansowania_Symbol>\r\n    <praw_formaWlasnosci_Symbol>214</praw_formaWlasnosci_Symbol>\r\n    <praw_organZalozycielski_Symbol />\r\n    <praw_organRejestrowy_Symbol>071930010</praw_organRejestrowy_Symbol>\r\n    <praw_rodzajRejestruEwidencji_Symbol>138</praw_rodzajRejestruEwidencji_Symbol>\r\n    <praw_podstawowaFormaPrawna_Nazwa>OSOBA PRAWNA</praw_podstawowaFormaPrawna_Nazwa>\r\n    <praw_szczegolnaFormaPrawna_Nazwa>SPÓŁKI Z OGRANICZONĄ ODPOWIEDZIALNOŚCIĄ</praw_szczegolnaFormaPrawna_Nazwa>\r\n    <praw_formaFinansowania_Nazwa>JEDNOSTKA SAMOFINANSUJĄCA NIE BĘDĄCA JEDNOSTKĄ BUDŻETOWĄ LUB SAMORZĄDOWYM ZAKŁADEM BUDŻETOWYM</praw_formaFinansowania_Nazwa>\r\n    <praw_formaWlasnosci_Nazwa>WŁASNOŚĆ KRAJOWYCH OSÓB FIZYCZNYCH</praw_formaWlasnosci_Nazwa>\r\n    <praw_organZalozycielski_Nazwa />\r\n    <praw_organRejestrowy_Nazwa>SĄD REJONOWY DLA WROCŁAWIA FABRYCZNEJ WE WROCŁAWIU, VI WYDZIAŁ GOSPODARCZY KRAJOWEGO REJESTRU SĄDOWEGO</praw_organRejestrowy_Nazwa>\r\n    <praw_rodzajRejestruEwidencji_Nazwa>REJESTR PRZEDSIĘBIORCÓW</praw_rodzajRejestruEwidencji_Nazwa>\r\n    <praw_jednostekLokalnych>0</praw_jednostekLokalnych>\r\n  </dane>\r\n</root>">]
response.size
 => 2
response.class
 => Array
response.first.class
 => GusBir1::Response::FullData
 response.first.to_h
 => {"praw_regon14"=>"00033150100000", "praw_nip"=>"5261040828", "praw_nazwa"=>"GŁÓWNY URZĄD STATYSTYCZNY", "praw_nazwaSkrocona"=>"GUS", "praw_numerWrejestrzeEwidencji"=>nil, "praw_dataPowstania"=>#<Date: 1975-12-15 ((2442762j,0s,0n),+0s,2299161j)>, "praw_dataRozpoczeciaDzialalnosci"=>#<Date: 1975-12-15 ((2442762j,0s,0n),+0s,2299161j)>, "praw_dataWpisuDoREGON"=>nil, "praw_dataZawieszeniaDzialalnosci"=>nil, "praw_dataWznowieniaDzialalnosci"=>nil, "praw_dataZaistnieniaZmiany"=>#<Date: 2009-02-20 ((2454883j,0s,0n),+0s,2299161j)>, "praw_dataZakonczeniaDzialalnosci"=>nil, "praw_dataSkresleniazRegon"=>nil, "praw_adSiedzKraj_Symbol"=>"PL", "praw_adSiedzWojewodztwo_Symbol"=>"14", "praw_adSiedzPowiat_Symbol"=>"65", "praw_adSiedzGmina_Symbol"=>"108", "praw_adSiedzKodPocztowy"=>"00925", "praw_adSiedzMiejscowoscPoczty_Symbol"=>"0919810", "praw_adSiedzMiejscowosc_Symbol"=>"0919810", "praw_adSiedzUlica_Symbol"=>"10013", "praw_adSiedzNumerNieruchomosci"=>"208", "praw_adSiedzNumerLokalu"=>nil, "praw_adSiedzNietypoweMiejsceLokalizacji"=>nil, "praw_numerTelefonu"=>"6083000", "praw_numerWewnetrznyTelefonu"=>nil, "praw_numerFaksu"=>"0226083863", "praw_adresEmail"=>"dgsek@stat.gov.pl", "praw_adresStronyinternetowej"=>"www.stat.gov.pl", "praw_adresEmail2"=>nil, "praw_adKorKraj_Symbol"=>"PL", "praw_adKorWojewodztwo_Symbol"=>"14", "praw_adKorPowiat_Symbol"=>"65", "praw_adKorGmina_Symbol"=>"108", "praw_adKorKodPocztowy"=>"00925", "praw_adKorMiejscowoscPoczty_Symbol"=>"0919810", "praw_adKorMiejscowosc_Symbol"=>"0919810", "praw_adKorUlica_Symbol"=>"14199", "praw_adKorNumerNieruchomosci"=>"208", "praw_adKorNumerLokalu"=>nil, "praw_adKorNietypoweMiejsceLokalizacji"=>nil, "praw_adKorNazwaPodmiotuDoKorespondencji"=>nil, "praw_adSiedzKraj_Nazwa"=>"POLSKA", "praw_adSiedzWojewodztwo_Nazwa"=>"MAZOWIECKIE", "praw_adSiedzPowiat_Nazwa"=>"m. st. Warszawa", "praw_adSiedzGmina_Nazwa"=>"Śródmieście", "praw_adSiedzMiejscowosc_Nazwa"=>"Warszawa", "praw_adSiedzMiejscowoscPoczty_Nazwa"=>"Warszawa", "praw_adSiedzUlica_Nazwa"=>"ul. Test-Krucza", "praw_adKorKraj_Nazwa"=>nil, "praw_adKorWojewodztwo_Nazwa"=>nil, "praw_adKorPowiat_Nazwa"=>nil, "praw_adKorGmina_Nazwa"=>nil, "praw_adKorMiejscowosc_Nazwa"=>nil, "praw_adKorMiejscowoscPoczty_Nazwa"=>nil, "praw_adKorUlica_Nazwa"=>nil, "praw_podstawowaFormaPrawna_Symbol"=>"2", "praw_szczegolnaFormaPrawna_Symbol"=>"01", "praw_formaFinansowania_Symbol"=>"2", "praw_formaWlasnosci_Symbol"=>"111", "praw_organZalozycielski_Symbol"=>"050000000", "praw_organRejestrowy_Symbol"=>nil, "praw_rodzajRejestruEwidencji_Symbol"=>"000", "praw_podstawowaFormaPrawna_Nazwa"=>"JEDNOSTKA ORGANIZACYJNA NIEMAJĄCA OSOBOWOŚCI PRAWNEJ", "praw_szczegolnaFormaPrawna_Nazwa"=>"ORGANY WŁADZY,ADMINISTRACJI RZĄDOWEJ", "praw_formaFinansowania_Nazwa"=>"JEDNOSTKA BUDŻETOWA", "praw_formaWlasnosci_Nazwa"=>"WŁASNOŚĆ SKARBU PAŃSTWA", "praw_organZalozycielski_Nazwa"=>"PREZES GŁÓWNEGO URZĘDU STATYSTYCZNEGO", "praw_organRejestrowy_Nazwa"=>nil, "praw_rodzajRejestruEwidencji_Nazwa"=>"PODMIOTY UTWORZONE Z MOCY USTAWY", "praw_jednostekLokalnych"=>"0"}
 response.first.body
 => "<root>\r\n  <dane>\r\n    <praw_regon14>00033150100000</praw_regon14>\r\n    <praw_nip>5261040828</praw_nip>\r\n    <praw_nazwa>GŁÓWNY URZĄD STATYSTYCZNY</praw_nazwa>\r\n    <praw_nazwaSkrocona>GUS</praw_nazwaSkrocona>\r\n    <praw_numerWrejestrzeEwidencji />\r\n    <praw_dataPowstania>1975-12-15</praw_dataPowstania>\r\n    <praw_dataRozpoczeciaDzialalnosci>1975-12-15</praw_dataRozpoczeciaDzialalnosci>\r\n    <praw_dataWpisuDoREGON />\r\n    <praw_dataZawieszeniaDzialalnosci />\r\n    <praw_dataWznowieniaDzialalnosci />\r\n    <praw_dataZaistnieniaZmiany>2009-02-20</praw_dataZaistnieniaZmiany>\r\n    <praw_dataZakonczeniaDzialalnosci />\r\n    <praw_dataSkresleniazRegon />\r\n    <praw_adSiedzKraj_Symbol>PL</praw_adSiedzKraj_Symbol>\r\n    <praw_adSiedzWojewodztwo_Symbol>14</praw_adSiedzWojewodztwo_Symbol>\r\n    <praw_adSiedzPowiat_Symbol>65</praw_adSiedzPowiat_Symbol>\r\n    <praw_adSiedzGmina_Symbol>108</praw_adSiedzGmina_Symbol>\r\n    <praw_adSiedzKodPocztowy>00925</praw_adSiedzKodPocztowy>\r\n    <praw_adSiedzMiejscowoscPoczty_Symbol>0919810</praw_adSiedzMiejscowoscPoczty_Symbol>\r\n    <praw_adSiedzMiejscowosc_Symbol>0919810</praw_adSiedzMiejscowosc_Symbol>\r\n    <praw_adSiedzUlica_Symbol>10013</praw_adSiedzUlica_Symbol>\r\n    <praw_adSiedzNumerNieruchomosci>208</praw_adSiedzNumerNieruchomosci>\r\n    <praw_adSiedzNumerLokalu />\r\n    <praw_adSiedzNietypoweMiejsceLokalizacji />\r\n    <praw_numerTelefonu>6083000</praw_numerTelefonu>\r\n    <praw_numerWewnetrznyTelefonu />\r\n    <praw_numerFaksu>0226083863</praw_numerFaksu>\r\n    <praw_adresEmail>dgsek@stat.gov.pl</praw_adresEmail>\r\n    <praw_adresStronyinternetowej>www.stat.gov.pl</praw_adresStronyinternetowej>\r\n    <praw_adresEmail2 />\r\n    <praw_adKorKraj_Symbol>PL</praw_adKorKraj_Symbol>\r\n    <praw_adKorWojewodztwo_Symbol>14</praw_adKorWojewodztwo_Symbol>\r\n    <praw_adKorPowiat_Symbol>65</praw_adKorPowiat_Symbol>\r\n    <praw_adKorGmina_Symbol>108</praw_adKorGmina_Symbol>\r\n    <praw_adKorKodPocztowy>00925</praw_adKorKodPocztowy>\r\n    <praw_adKorMiejscowoscPoczty_Symbol>0919810</praw_adKorMiejscowoscPoczty_Symbol>\r\n    <praw_adKorMiejscowosc_Symbol>0919810</praw_adKorMiejscowosc_Symbol>\r\n    <praw_adKorUlica_Symbol>14199</praw_adKorUlica_Symbol>\r\n    <praw_adKorNumerNieruchomosci>208</praw_adKorNumerNieruchomosci>\r\n    <praw_adKorNumerLokalu />\r\n    <praw_adKorNietypoweMiejsceLokalizacji />\r\n    <praw_adKorNazwaPodmiotuDoKorespondencji />\r\n    <praw_adSiedzKraj_Nazwa>POLSKA</praw_adSiedzKraj_Nazwa>\r\n    <praw_adSiedzWojewodztwo_Nazwa>MAZOWIECKIE</praw_adSiedzWojewodztwo_Nazwa>\r\n    <praw_adSiedzPowiat_Nazwa>m. st. Warszawa</praw_adSiedzPowiat_Nazwa>\r\n    <praw_adSiedzGmina_Nazwa>Śródmieście</praw_adSiedzGmina_Nazwa>\r\n    <praw_adSiedzMiejscowosc_Nazwa>Warszawa</praw_adSiedzMiejscowosc_Nazwa>\r\n    <praw_adSiedzMiejscowoscPoczty_Nazwa>Warszawa</praw_adSiedzMiejscowoscPoczty_Nazwa>\r\n    <praw_adSiedzUlica_Nazwa>ul. Test-Krucza</praw_adSiedzUlica_Nazwa>\r\n    <praw_adKorKraj_Nazwa />\r\n    <praw_adKorWojewodztwo_Nazwa />\r\n    <praw_adKorPowiat_Nazwa />\r\n    <praw_adKorGmina_Nazwa />\r\n    <praw_adKorMiejscowosc_Nazwa />\r\n    <praw_adKorMiejscowoscPoczty_Nazwa />\r\n    <praw_adKorUlica_Nazwa />\r\n    <praw_podstawowaFormaPrawna_Symbol>2</praw_podstawowaFormaPrawna_Symbol>\r\n    <praw_szczegolnaFormaPrawna_Symbol>01</praw_szczegolnaFormaPrawna_Symbol>\r\n    <praw_formaFinansowania_Symbol>2</praw_formaFinansowania_Symbol>\r\n    <praw_formaWlasnosci_Symbol>111</praw_formaWlasnosci_Symbol>\r\n    <praw_organZalozycielski_Symbol>050000000</praw_organZalozycielski_Symbol>\r\n    <praw_organRejestrowy_Symbol />\r\n    <praw_rodzajRejestruEwidencji_Symbol>000</praw_rodzajRejestruEwidencji_Symbol>\r\n    <praw_podstawowaFormaPrawna_Nazwa>JEDNOSTKA ORGANIZACYJNA NIEMAJĄCA OSOBOWOŚCI PRAWNEJ</praw_podstawowaFormaPrawna_Nazwa>\r\n    <praw_szczegolnaFormaPrawna_Nazwa>ORGANY WŁADZY,ADMINISTRACJI RZĄDOWEJ</praw_szczegolnaFormaPrawna_Nazwa>\r\n    <praw_formaFinansowania_Nazwa>JEDNOSTKA BUDŻETOWA</praw_formaFinansowania_Nazwa>\r\n    <praw_formaWlasnosci_Nazwa>WŁASNOŚĆ SKARBU PAŃSTWA</praw_formaWlasnosci_Nazwa>\r\n    <praw_organZalozycielski_Nazwa>PREZES GŁÓWNEGO URZĘDU STATYSTYCZNEGO</praw_organZalozycielski_Nazwa>\r\n    <praw_organRejestrowy_Nazwa />\r\n    <praw_rodzajRejestruEwidencji_Nazwa>PODMIOTY UTWORZONE Z MOCY USTAWY</praw_rodzajRejestruEwidencji_Nazwa>\r\n    <praw_jednostekLokalnych>0</praw_jednostekLokalnych>\r\n  </dane>\r\n</root>"
 ```

## Example

```ruby
company = OpenStruct.new

gus_response = GusBir1.find_and_get_full_data(nip: 5261040828)
if gus_response.first
  gus_data = gus_response.first.to_h
  prefix = gus_data.first.first.split('_').first
  company.name = gus_data["#{prefix}_nazwaSkrocona"]
  company.name = gus_data["#{prefix}_nazwa"] if company.name.blank?
  company.address = gus_data["#{prefix}_adSiedzUlica_Nazwa"]
  company.address += " " + gus_data["#{prefix}_adSiedzNumerNieruchomosci"] if gus_data["#{prefix}_adSiedzNumerNieruchomosci"]
  company.address += "/#{gus_data["#{prefix}_adSiedzNumerLokalu"]}" if gus_data["#{prefix}_adSiedzNumerLokalu"]
  company.zip = gus_data["#{prefix}_adSiedzKodPocztowy"].insert(2,'-')
  company.city = gus_data["#{prefix}_adSiedzMiejscowoscPoczty_Nazwa"]
  company.country = gus_data["#{prefix}_adSiedzKraj_Nazwa"]
  company.regon = gus_data["#{prefix}_regon14"] if gus_data["#{prefix}_regon14"]
  company.regon = gus_data["#{prefix}_regon9"] if gus_data["#{prefix}_regon9"]
  company.nip = gus_data["#{prefix}_nip"] if gus_data["#{prefix}_nip"]
end

company
 => #<OpenStruct name="GUS", address="ul. Test-Krucza 208", zip="00-925", city="Warszawa", country="POLSKA", regon="00033150100000", nip="5261040828">
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `COVERAGE=1 rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/espago/gus_bir1.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

