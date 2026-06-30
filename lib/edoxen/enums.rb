# frozen_string_literal: true

module Edoxen
  # Single source of truth for every enum used by the Edoxen information model.
  #
  # Mirrors ../edoxen-model/models/*.lutaml, deduped.
  # Both:
  #   * Ruby model attribute declarations (`attribute :type, :string, values: Enums::ACTION_TYPE`)
  #   * JSON-Schema (`schema/edoxen.yaml`)
  # reference these constants.
  #
  # The schema <-> Ruby enum-sync spec asserts the YAML schema's enum arrays
  # equal these arrays. If you change a constant here, change the schema in
  # the same PR.
  module Enums
    ACTION_TYPE = %w[
      adopts thanks approves decides declares asks invites
      resolves confirms welcomes recommends requests congratulates
      instructs urges appoints calls-upon encourages affirms elects
      authorizes charges states remarks judges sanctions abrogates empowers
    ].freeze

    CONSIDERATION_TYPE = %w[
      having noting recognizing acknowledging recalling reaffirming
      considering taking-into-account pursuant-to bearing-in-mind
      emphasizing concerned accepts observing referring acting empowers
    ].freeze

    RESOLUTION_TYPE = %w[resolution recommendation decision declaration].freeze

    RESOLUTION_RELATION_TYPE = %w[
      annexOf hasAnnex updates refines replaces considers
    ].freeze

    RESOLUTION_DATE_TYPE = %w[adoption drafted discussed].freeze

    APPROVAL_TYPE = %w[affirmative negative].freeze

    APPROVAL_DEGREE = %w[unanimous majority minority].freeze

    URL_KIND = %w[access report].freeze
  end
end
