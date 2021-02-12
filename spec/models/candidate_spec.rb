require 'rails_helper'

RSpec.describe Candidate, type: :model do
  describe 'validations' do
    it { is_expected.to validate_uniqueness_of(:first_name) }
    it { is_expected.to validate_uniqueness_of(:last_name) }
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_uniqueness_of(:phone) }


    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:phone) }
  end
end
