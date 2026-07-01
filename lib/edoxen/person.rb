# frozen_string_literal: true

module Edoxen
  # Identity + role + affiliation + contact. Used for meeting officers
  # (chair, secretary, local contact) and host-ref contacts.
  class Person < Lutaml::Model::Serializable
    attribute :name, :string
    attribute :role, :string
    attribute :affiliation, :string
    attribute :email, :string
    attribute :phone, :string
    attribute :orcid, :string
  end
end
