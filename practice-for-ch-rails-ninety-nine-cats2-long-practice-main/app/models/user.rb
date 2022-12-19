class User < ApplicationRecord
   validates :username, :session_token, presence: true, unique: true
   validates :password_digest, presence: {message: 'Password cannot be blank.'}
   validates :password, length: { minimum: 6 }, allow_nil: true

   before_validation :ensure_session_token

   attr_reader :password

   def self.find_by_credentials(username, password)
      user = User.find_by(username: username)

      if user && user.is_password?(password)
         user
      else 
         nil
      end
   end

   def password=(new_pass)
      self.password_digest = BCrypt::Password.create(new_pass)
      @password = new_pass
   end

   def is_password?(password)
      BCrypt::Password.new(self.password_digest).is_password?(password)
   end  

   def generate_new_session_token
      loop do
         session_token = SecureRandom::urlsafe_base64(16)
         return session_token unless User.exists?(session_token: session_token)
      end
   end

   def reset_session_token!
      self.session_token = generate_new_session_token
      self.save!
      self.session_token
   end

   def ensure_session_token
      self.session_token |||= generate_new_session_token
   end

end
