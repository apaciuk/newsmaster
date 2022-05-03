# frozen_string_literal: true

class LocOutput < Actor
  input :location

  def call
    puts "Hello #{location.name}!"
  end
end
