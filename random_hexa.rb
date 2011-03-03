#!/usr/bin/env ruby -wKU

# 
#  RandomHexa
# 
#  Generate reproductible random array of hexa colors
#  
#  Created by Nicolas Cavigneaux on 2011-03-04.
#  Copyright 2011 Bounga. All rights reserved.
# 
# =========
# = Usage =
# =========
# 
# RandomHexa.new(1234).to_a
# => ["#76b2f", "#66e2d3", "#428526"]
# 
# RandomHexa.new(5678).to_a
# => ["#448874", "#93f897", "#30693e"]
# 
# RandomHexa.new(1234).to_a
# => ["#76b2f", "#66e2d3", "#428526"]
#
# RandomHexa.new(5678).to_a(8)
# => ["#448874", "#93f897", "#30693e", "#3edb92", "#bf713f", "#f088bc", "#d45d8d", "#d8f0fd"]

class RandomHexa
  attr_reader :seed
  
  def initialize(seed)
    @seed = seed
    srand @seed
  end
  
  def to_a(size=3)
    Array.new(size) { |i| "#" + rand(0xffffff).to_s(16) }
  end
end

