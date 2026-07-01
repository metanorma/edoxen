# frozen_string_literal: true

module Edoxen
  # One entry on an Agenda. `label` is the visible identifier (e.g.,
  # "5.2"); `kind` discriminates numbered/unnumbered/header/opening/
  # closing; `outcome` records what happened; `resolution_ref`
  # optionally links to the URN of the resolution this item produced.
  class AgendaItem < Lutaml::Model::Serializable
    attribute :label, :string
    attribute :kind, :string, values: Enums::AGENDA_ITEM_KIND
    attribute :title, :string
    attribute :description, :string
    attribute :references, Reference, collection: true
    attribute :outcome, :string, values: Enums::AGENDA_ITEM_OUTCOME
    attribute :resolution_ref, :string
  end
end
