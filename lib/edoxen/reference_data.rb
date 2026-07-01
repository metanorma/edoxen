# frozen_string_literal: true

module Edoxen
  # Built-in reference data for ISO codes used across the Edoxen model:
  # ISO 3166-1 alpha-2 country codes, ISO 639-3 language codes, ISO
  # 15924 script codes, and UN/LOCODEs.
  #
  # UN/LOCODE lookups delegate to the `unlocode` gem (the canonical
  # Ruby registry of the UNECE UN/LOCODE dataset). The frozen
  # ReferenceData::UNLOCODES list stays as a curated offline subset
  # — used by specs and consumers that don't want to load the full
  # ~100k-entry registry.
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
    # Hard require the unlocode gem. It's a declared runtime dep, so a
    # clean install of edoxen brings it in. The bundled dataset ships
    # 4 sample entries; full coverage requires `rake unlocode:fetch`
    # from the unlocode gem.
    require "unlocode"

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

    # Curated offline subset of UN/LOCODEs — the cities ISO/TC 154 and
    # OIML actually meet in plus the major transit hubs. Used by specs
    # and consumers that don't want to load the full registry. For
    # arbitrary lookups, use {find_unlocode}.
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

    class << self
      # Look up a UN/LOCODE entry via the canonical `unlocode` gem.
      # Returns an `Unlocode::Entry` (with `#name`, `#country`,
      # `#coordinates`, `#iata`, `#functions`, etc.) or nil when the
      # code is not in the registry.
      #
      # Requires the full UN/LOCODE dataset to be loaded. The gem
      # ships a 4-entry sample by default; run `rake unlocode:fetch`
      # from the unlocode gem to populate the full ~100k-entry
      # registry.
      #
      # @param code [String, #to_s] 5-character UN/LOCODE
      # @return [Unlocode::Entry, nil]
      def find_unlocode(code)
        Unlocode.find(code.to_s.upcase)
      end

      # True when the code resolves to a real UN/LOCODE entry via the
      # canonical registry. Use this when validating user-supplied
      # city codes; use the schema's pattern check for cheap shape
      # validation.
      def unlocode_exists?(code)
        !find_unlocode(code).nil?
      end
    end
  end
end
