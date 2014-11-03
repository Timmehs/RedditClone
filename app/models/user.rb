# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string(255)      not null
#  password_digest :string(255)      not null
#  session_token   :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  validates :username, :session_token, :password_digest, presence: true
  after_initialize :ensure_session_token
  validates :username, uniqueness: true
  
  has_many(
    :comments,
    class_name: "Comment",
    foreign_key: :author_id,
    primary_key: :id
  )
  
  has_many(
    :subs,
    class_name: "Sub",
    foreign_key: :moderator_id,
    primary_key: :id
  )
    
  has_many(
    :posts,
    class_name: "Post",
    foreign_key: :author_id,
    primary_key: :id
  )
  
  def password=(raw_password)
    self.password_digest = BCrypt::Password.create(raw_password)
  end
  
  def password_digest
    BCrypt::Password.new(super)
  end
  
  def is_password?(password)
    password_digest.is_password?(password)
  end
  
  def generate_session_token
    SecureRandom.urlsafe_base64
  end
  
  def reset_session_token!
    self.session_token = generate_session_token
    self.save
  end
  
  def ensure_session_token
    self.session_token ||= generate_session_token
  end
end
