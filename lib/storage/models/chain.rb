class Chain < ActiveRecord::Base
  belongs_to :next, class_name: "Chain"
  belongs_to :word
  belongs_to :source
end
