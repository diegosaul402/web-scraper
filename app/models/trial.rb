# frozen_string_literal: true

class Trial < ApplicationRecord
  has_many :notifications, dependent: :destroy
end
