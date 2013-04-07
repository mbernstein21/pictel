class AddAttachmentToUsers < ActiveRecord::Migration
  def change
    add_attachment :cards, :attachments64
  end
end
