require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }  # Usamos `build` para crear una instancia sin guardar en la base de datos.

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(user).to be_valid
    end

    it 'is not valid without a name' do
      user.name = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without an email' do
      user.email = nil
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user.password = nil
      expect(user).to_not be_valid
    end

    it 'is not valid with a password shorter than 6 characters' do
      user.password = 'short'
      expect(user).to_not be_valid
    end

    it 'is not valid without a unique email' do
      create(:user, email: 'user@example.com')  # Crea un usuario con este email
      user.email = 'user@example.com'             # Asigna el mismo email
      expect(user).to_not be_valid
    end

    it 'is valid with a unique email' do
      user.email = 'unique@example.com'
      expect(user).to be_valid
    end
  end
end
