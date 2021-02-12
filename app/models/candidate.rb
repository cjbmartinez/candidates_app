class Candidate < ApplicationRecord

  validates :first_name, :last_name, :email, :phone, presence: true, uniqueness: true
end
