class Query < ActiveRecord::Base
	validates :journal, :presence => true
	validates :retmax, :numericality => { :less_than => 100000 }
	validates :mindate, :presence => true
	validates :maxdate, :presence => true
	belongs_to :user
end
