# frozen_string_literal: true

class Trial < ApplicationRecord
  has_many :notifications, dependent: :destroy

  before_save :sanitize

  def sanitize
    self.actor = actor.remove(/\AActor: /)
    self.defendant = defendant.remove(/\ADemandado: /)
    self.expedient = expedient.match(/[\d].+\/[\d].+/).to_s
  end
end
