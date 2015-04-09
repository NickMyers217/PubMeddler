class Query < ActiveRecord::Base
	validates :title,   :presence => true
	validates :journal, :presence => true
	validates :retmax,  :numericality => { :less_than => 100 }
	validates :mindate, :presence => true
	validates :maxdate, :presence => true
	belongs_to :user
end
