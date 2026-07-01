# frozen_string_literal: true

module Edoxen
  # Built-in reference data for ISO codes used across the Edoxen model:
  # ISO 3166-1 alpha-2 country codes, ISO 639-3 language codes, ISO
  # 15924 script codes, and UN/LOCODEs for the cities where ISO/TC 154
  # and OIML actually meet.
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
  # * https://unece.org/trade/cefact/unlocode-code-list-country-and-territory
  #
  # UN/LOCODE format: 2-letter ISO 3166-1 country code + 3-character
  # location alphanumeric (e.g., FRPAR = Paris, France; HKHKG = Hong
  # Kong; THCNM = Chiang Mai). UN-maintained, supersedes the
  # airport-centric IATA city codes edoxen previously used.
  module ReferenceData
    # ISO 3166-1 alpha-2 — countries ISO/TC 154 / OIML / BIPM operate in.
    # Two-letter uppercase.
    COUNTRY_CODES = %w[
      AE AF AR AT AU BE BG BR BY CA CH CL CN CO CY CZ DE DK EE ES FI FR
      GB GR HK HR HU ID IE IL IN IS IT JP KE KR LK LT LU LV MT MX MY NL NO PH
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

    # UN/LOCODEs — 5-character (2-letter country + 3-char location)
    # for cities where ISO/TC 154 or OIML has actually held a meeting,
    # plus the major hubs their members transit. Drawn from the UNECE
    # UN/LOCODE code list (2025-1).
    #
    # Mapping is city-to-LOCODE: the LOCODE sometimes names the
    # airport or seaport rather than the city itself, but for
    # meeting-venue purposes the closest LOCODE is correct.
    UNLOCODES = %w[
      AUMEL ATVIE BEBRU BGSOF BRBSB CHGVA CNCAN CNHKG CNSHA CNXSZ COCTG
      CYLCA CZPRG DEBER DEHAM DEFRA DKCPH ESMAD FIHEL FRARC FRLYS FRMRS
      FRPAR GBLON HKHKG HUBUD IDJKT IEDUB IEORK ILTLV INDEL ISREY ITROM
      JPTYO KEMBA KRSEL LKCMB LVRIX LULUX MYKUL NLRTM NOOSL NZAKL PHMNL
      PLWAW PTLIS ROBUH RSBEG SESTO SGSIN SKBTS THBKK THCNM TRIST TWTPE
      UAIEV USMIA USNYC USORL VNSGN ZACPT
    ].freeze

    # @deprecated Use {UNLOCODES}. Retained for one release to ease
    # migration; will be removed in the next minor.
    CITY_CODES = UNLOCODES
  end
end
