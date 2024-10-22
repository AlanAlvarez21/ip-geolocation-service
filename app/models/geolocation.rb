class Geolocation < ApplicationRecord
    validates :input, presence: true
end
