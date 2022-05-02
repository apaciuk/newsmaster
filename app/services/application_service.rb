# frozen_string_literal: true

class ApplicationService < ActiveRecord::Base
  def self.call(*args, &block)
    new(*args, &block).call
  end
end
