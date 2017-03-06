require 'rails_helper'

RSpec.describe PagesController do
  describe 'GET index' do
    it 'lists the pages' do
      page1 = Page.create(title: 'Foo', body: 'Body', url: 'http://example.org')
      page2 = Page.create(title: 'Bar', body: 'Body', url: 'http://example.com')

      get :index
      actual = JSON.parse(response.body)
      expected = [JSON.parse(page1.to_json), JSON.parse(page2.to_json)]

      expect(actual).to match_array(expected)
    end
  end

  describe 'POST create' do
    subject(:post_create) do
      post :create, params: params
    end

    around(:each) do |example|
      VCR.use_cassette(:kytrinyx, record: :once) do
        example.run
      end
    end

    context 'with valid params' do
      let(:params) { { url: 'http://www.kytrinyx.com/' } }

      it 'creates a page' do
        expect { post_create }.to change(Page, :count).by(1)
      end

      it 'creates a page with the right title' do
        post_create
        page = Page.last
        expect(page.title).to eq('KYTRINYX')
      end

      it 'creates a page with the desired content' do
        post_create
        page = Page.last
        expect(page.body)
          .to match('I am a programmer, and I mostly work on web backends in Go and Ruby.')
      end

      it 'sets the url' do
        post_create
        page = Page.last
        expect(page.url).to eq('http://www.kytrinyx.com/')
      end
    end
  end
end
