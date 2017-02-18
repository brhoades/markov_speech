class Chain < ActiveRecord::Base
  belongs_to :next, class_name: "Chain", foreign_key: 'next'
  belongs_to :word
  belongs_to :source
end
