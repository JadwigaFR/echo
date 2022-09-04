# frozen_string_literal: true

class Endpoint < ApplicationRecord
  HTTP_VERBS = %w[GET HEAD POST PUT DELETE CONNECT OPTIONS TRACE].freeze

  validates :verb, :path, :response_code, presence: true
  validates_inclusion_of :verb, in: HTTP_VERBS
end
