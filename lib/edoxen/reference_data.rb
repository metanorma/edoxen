# frozen_string_literal: true

module Edoxen
  # Built-in reference data for ISO codes used across the Edoxen model:
  # ISO 3166-1 alpha-2 country codes, ISO 639-3 language codes, and
  # ISO 15924 script codes.
  #
  # Frozen, alphabetically sorted, single source of truth. The intent
  # is not to be exhaustive — it is to be enough that typos in real
  # fixtures surface immediately via the corresponding spec.
  #
  # When a real consumer needs a value that's not here, add it AND
  # update the corresponding spec; both lists must stay in lockstep.
  #
  # Reference data sources:
  # * https://www.iso.org/iso-3166-country-codes.html
  # * https://iso639-3.sil.org/
  # * https://unicode.org/iso15924/
  module ReferenceData
    # ISO 3166-1 alpha-2 — countries ISO/TC 154 / OIML / BIPM operate in.
    # Extend as fixtures require. Two-letter uppercase.
    COUNTRY_CODES = %w[
      AE AF AR AT AU BE BG BR BY CA CH CL CN CO CY CZ DE DK EE ES FI FR
      GB GR HK HR HU ID IE IL IN IS IT JP KE KR LT LU LV MT MX MY NL NO
      NZ PL PT RO RS RU SA SE SG SI SK TH TN TR TW UA US VN ZA
    ].freeze

    # ISO 639-3 — languages actually used in the edoxen fixtures
    # (eng + fra in OIML, plus the ISO official languages).
    # Three-letter lowercase.
    LANGUAGE_CODES = %w[
      ara chi deu eng fra jpn rus spa zho
    ].freeze

    # ISO 15924 — scripts. Latn + Cyrl + Hant + Hans cover every script
    # ISO and OIML resolutions are written in.
    SCRIPT_CODES = %w[
      Arab Cyrl Hans Hant Hang Hebr Jpan Kore Latn
    ].freeze

    # IATA city codes — three-letter uppercase. Limited to cities
    # where ISO/TC 154 or OIML has actually held a meeting. Extend as
    # needed.
    CITY_CODES = %w[
      AKL ARN BKK BRI BRU BUD CDG CMB CPT FRA GRZ HAM HKG IST JFK KUL
      LON LUX MAD MNL MRS MUC NBO ORY PAR PRG RIX SEL SIN SOF STR SYD
      TPE VIE WAW
    ].freeze
  end
end
