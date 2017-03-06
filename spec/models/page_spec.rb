require 'rails_helper'

RSpec.describe Page do
  context 'validations' do
    let(:page) do
      Page.new(title: 'Some page title', body: '<h1>Title</h1>',
               url: 'http://example.org')
    end

    it 'is valid with all fields' do
      expect(page).to be_valid
    end

    it 'is not valid without title' do
      page.title = nil
      expect(page).not_to be_valid
    end

    it 'is not valid without body' do
      page.body = nil
      expect(page).not_to be_valid
    end

    it 'is not valid without url' do
      page.url = nil
      expect(page).not_to be_valid
    end
  end
end
