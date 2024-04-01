# spec/models/user_spec.rb

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#subsidiary?' do
    it 'returns true if user belongs to the specified subsidiary' do
      subsidiary = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary, role: :manager)

      result = user.subsidiary?(subsidiary)

      expect(result).to be true
    end

    it 'returns false if user does not belong to the specified subsidiary' do
      subsidiary1 = create(:subsidiary)
      subsidiary2 = create(:subsidiary)
      user = create(:user, subsidiary: subsidiary1)

      result = user.subsidiary?(subsidiary2)

      expect(result).to be false
    end
  end
end
