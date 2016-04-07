require 'spec_helper'

describe User do
  it { is_expected.to respond_to(:username) }
  it { is_expected.to respond_to(:name) }

  context 'validations' do
    let(:user) { build :user }

    it 'has a valid blank factory' do
      expect(create(:user)).to be_valid
    end

    context 'username' do
      it { is_expected.to allow_value('dak').for(:username) }
      it { is_expected.not_to allow_value('').for(:username) }

      it 'validates uniqueness' do
        create :user, username: 'dak'
        expect(user).not_to allow_value('dak').for(:username)
      end

      it 'validates uniqueness with case insensitivity' do
        create :user, username: 'dAk'
        expect(user).not_to allow_value('DaK').for(:username).ignoring_interference_by_writer
      end

      it 'validates uniqueness with whitespace insensitivity' do
        create(:user).update_attributes(username: 'dak     ')
        expect(user).not_to allow_value('   dak').for(:username).ignoring_interference_by_writer
      end
    end
  end

  describe '.active' do
    let!(:active_users) { create_list :user, 2 }
    let!(:locked_users) { create_list :user, 2, :locked }

    it 'returns all active users' do
      expect(User.active).to match_array(active_users)
    end
  end

  describe '.for_admin' do
    let!(:dak) { create :user, username: 'dak' }
    let!(:ai) { create :user, username: 'ai' }
    let!(:deleted_user) { create :user, :deleted, username: 'zzz' }

    it 'returns all users ordered by username' do
      expect(User.for_admin).to eq([ai, dak])
    end

    it 'passes show option to actual' do
      expect(User.for_admin('all')).to eq([ai, dak, deleted_user])
    end
  end

  describe 'blog' do
    let!(:dak) { create :user, username: 'dak' }
    let!(:aratak) { create :user, username: 'aratak' }
    let!(:ai) { create :user, username: 'ai' }
    let!(:first_page) { create :page, :blog, url: '/blog/dak/first' }
    let!(:second_page) { create :page, :blog, url: '/blog/dak/second' }
    let!(:wrong_page) { create :page, :blog, url: '/blog/aratak/first' }
    let!(:deleted_page) { create :page, :blog, :deleted,  url: '/blog/dak/deleted' }

  end

  describe '#role' do
    context 'for admin' do
      subject { create :user, :admin, username: 'dak' }
      its(:role) { is_expected.to eq :admin}
    end

    context 'for regular' do
      subject { create :user, username: 'ai' }
      its(:role) { is_expected.to eq :regular}
    end
  end

  describe '#name' do
    it 'returns name if present' do
      user = create :user, username: 'dak', name: 'Dmitriy Kiriyenko'
      expect(user.name).to eq('Dmitriy Kiriyenko')
    end

    it 'returns username if name is not present' do
      user = create :user, username: 'dak'
      expect(user.name).to eq('dak')
    end
  end

  describe 'safe deleting' do
    it_behaves_like 'safe deleting model' do
      let(:model_factory) { :user }
      let(:model_class) { User }
    end
  end
end
