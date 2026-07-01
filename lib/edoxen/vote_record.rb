# frozen_string_literal: true

module Edoxen
  # A single vote on a Resolution, recorded against the meeting at
  # which the vote was taken. Mirrors
  # edoxen-model/models/vote_record.lutaml. Each record carries the
  # person, their affiliation (national body / liaison / committee),
  # and the outcome (affirmative / negative / abstain / absent /
  # not_applicable).
  class VoteRecord < Lutaml::Model::Serializable
    attribute :resolution_ref, :string
    attribute :person, Person
    attribute :affiliation, :string
    attribute :vote, :string, values: Enums::VOTE_TYPE
    attribute :notes, :string

    key_value do
      map "resolution_ref", to: :resolution_ref
      map "person", to: :person
      map "affiliation", to: :affiliation
      map "vote", to: :vote
      map "notes", to: :notes
    end
  end
end
