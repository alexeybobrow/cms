# encoding: UTF-8

require 'spec_helper'

describe 'liquid variables management' do
  let!(:user) { create :user }

  before do
    sign_in user
  end

  context 'read' do
    let!(:width) { create :liquid_variable, name: 'width', value: '100px' }
    let!(:color) { create :liquid_variable, name: 'color', value: 'red' }

    it 'shows variables list' do
      visit cms.admin_liquid_variables_path
      expect(page).to have_content('width 100px')
      expect(page).to have_content('color red')
    end
  end

  context 'create' do
    it 'creates new variable' do
      visit cms.admin_liquid_variables_path
      click_on 'Create new variable'

      fill_in 'Name', with: 'height'
      fill_in 'Value', with: '100%'

      click_on 'Create Liquid variable'

      expect(page).to have_content('height 100%')
    end
  end

  context 'update' do
    let!(:show_toolbar) { create :liquid_variable, name: 'show_toolbar', value: '1' }

    it 'edits variable fields' do
      visit cms.admin_liquid_variables_path
      click_on 'show_toolbar'

      fill_in 'Value', with: '0'
      click_on 'Update Liquid variable'

      expect(page).to have_content('show_toolbar 0')
    end
  end
end
