module Markov
  module Models
    class Word < ActiveRecord::Base
    end
  end
end

include Markov::Models
