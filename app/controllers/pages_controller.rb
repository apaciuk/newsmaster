# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    LocQuery.call # => <ServiceActor::Result…>
  end
end
