class Card < ActiveRecord::Base
  attr_accessible :author, :current
  
  def self.last_card_type
  	order("created_at asc").last.type
  end
  # relates the card to the stack
  belongs_to :stack, counter_cache: true
end

class TextCard < Card
	attr_accessible :data_text
end

class PictureCard < Card
	attr_accessible :data_picture, :attachment64
 
	before_validation :save_attachment64
 
	has_attached_file :attachment, :storage => :s3, :s3_credentials => "#{RAILS_ROOT}/config/aws.yml",
                                 :path => "messages_images/:id/:style/:filename",
                                 :styles => { :original => ['400x400>'],
                                              :normal => ['400x400>'],
                                              :mini => ['137x137>']
                                            },
                                 :default_style => :normal
  private
    def save_attachment64
      File.open("tmp/reply.png", "wb") { |f| f.write(Datafy::decode_data_uri(attachment64)[0]) }  
      self.attachment = File.open("tmp/reply.png", "r")
    end
end