# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  title      :string(255)      not null
#  url        :string(255
#  content    :text
#  author_id  :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
  validates :title, :author_id, presence: true

  has_many :post_subs, inverse_of: :post, dependent: :destroy
  has_many :subs, through: :post_subs, source: :sub
  has_many :comments, inverse_of: :post


  def set_post_subs(sub_ids)
    self.post_subs.each do |ps|
      self.post_subs.destroy(ps) if sub_ids.nil? || !sub_ids.include?(ps.sub_id)
    end

    unless sub_ids.nil?
      sub_ids.each do |i|
        self.post_subs.create!(post_id: self.id, sub_id: i)
      end
    end
  end

  belongs_to(
    :author,
    class_name: "User",
    foreign_key: :author_id,
    primary_key: :id
  )

end
