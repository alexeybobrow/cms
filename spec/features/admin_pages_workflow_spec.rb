require 'spec_helper'

describe Page do
  let!(:user) { create :user }
  let!(:about_us) { create :page, :draft, url: '/about' }
  let!(:blog) { create :page, url: '/blog', content_body: '{% snippet blog_app %}' }

  describe 'in draft' do
    it 'should not be visible if user wasn\'t authenticated' do
      visit '/about'
      expect(page.status_code).to be 404
    end

    it 'should be visible if user was authenticated' do
      sign_in user
      visit '/about'

      expect(page.status_code).to be 200
    end

    it 'can be published by admin' do
      sign_in user
      visit cms.admin_page_path(about_us)
      click_on 'Publish'

      expect(page).to have_content('Unpublish')
      expect(about_us.rates).to be_empty
    end

    context 'when it is blog post' do
      let!(:article) { create :page, :blog, :draft, url: '/blog/article', content_body: 'Article About Us' }

      it 'generates fake rating after first publishing' do
        sign_in user
        expect(article.rates).to be_empty
        visit cms.admin_page_path(article)

        click_on 'Publish'
        expect(page).to have_content('Unpublish')
        expect(article.rates).not_to be_empty

        click_on 'Unpublish'
        expect { click_on 'Publish' }.not_to change { article.rates }
      end

      context 'user has been authenticated' do
        before { sign_in user }

        it 'should be visible' do
          visit '/blog/article'
          expect(page.status_code).to be 200
        end

        it 'should not be visible on blogs page', js: true do
          visit '/blog'

          expect(page).not_to have_content('Article About Us')
        end
      end

      context 'user has not been authenticated' do
        it 'should not be visible' do
          visit '/blog/article'
          save_page
          expect(page.status_code).to be 404
        end

        it 'should not be visible on blogs page' do
          visit '/blog'
          expect(page).to have_no_content('Article About Us')
        end
      end
    end
  end

  describe 'was published' do
    before { about_us.publish! }

    it 'can be sent to drafts by admin' do
      sign_in user
      visit cms.admin_page_path(about_us)
      click_on 'Unpublish'

      expect(page).to have_content('Publish')
    end
  end
end
