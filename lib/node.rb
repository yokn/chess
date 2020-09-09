# frozen_string_literal: true

class Node
  attr_accessor :data, :parent
  def initialize(data, parent = nil)
    @data = data
    @parent = parent
  end
end
