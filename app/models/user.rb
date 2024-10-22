class User < ApplicationRecord
    enum role: [ :default, :admin ]
    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :password, presence: true, length: { minimum: 6 }

    has_secure_password

    def admin?
      role == "admin"
    end
end
