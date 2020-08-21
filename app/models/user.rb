class User < ApplicationRecord
    has_secure_token
    has_one :monster
    has_many :todo
    validates :name, presence: true, uniqueness: true
end
