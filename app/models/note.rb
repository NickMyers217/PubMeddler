class Note < ActiveRecord::Base
	validates :user_id, :presence => true
	validates :pmid, 	:presence => true
	validates :text, 	:presence => true
	belongs_to :user
end
