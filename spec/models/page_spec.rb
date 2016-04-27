require 'spec_helper'

describe Page do
  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:name) }
  it { is_expected.to respond_to(:url) }
  it { is_expected.to respond_to(:content) }
  it { is_expected.to respond_to(:annotation) }
  it { is_expected.to respond_to(:posted_at) }

  it 'has a valid blank factory' do
    expect(create(:page)).to be_valid
  end

  describe '.public_get' do
    let!(:page) { create :page, url: '/new_world' }
    let!(:root_page) { create :page, url: '/' }
    let!(:deleted_page) { create :page, :deleted, url: '/deleted' }

    it 'finds by url' do
      expect(Page.public_get('new_world')).to eq(page)
    end

    it 'finds by url if leading slash' do
      expect(Page.public_get('/new_world')).to eq(page)
    end

    it 'finds root page' do
      expect(Page.public_get('')).to eq(root_page)
    end

    it 'finds root page if nil' do
      expect(Page.public_get(nil)).to eq(root_page)
    end

    it 'finds root page if leading slash' do
      expect(Page.public_get('/')).to eq(root_page)
    end

    it 'finds page by id' do
      expect(Page.public_get(root_page.id.to_s)).to eq(root_page)
    end

    it 'converts to id correctly' do
      some_crazy_slug = "#{root_page.id}-text"
      expect { Page.public_get(some_crazy_slug) }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises record not found if there is nothing' do
      expect { Page.public_get('/missing') }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'raises record not found if page is deleted' do
      expect { Page.public_get('/deleted') }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '.scoped_with_array' do
    it 'returns lambda for search in array' do
      expect(Page.scoped_with_array(:test)).to be_kind_of(Proc)
    end
  end

  describe '.by_author' do
    let!(:om) { create :page, authors: ['David Nolen'] }
    let!(:clojure) { create :page, authors: ['David Nolen', 'Hickey'] }

    it 'searches pages by author' do
      expect(Page.by_author('david-nolen')).to eq([om, clojure])
      expect(Page.by_author('hickey')).to eq([clojure])
    end
  end

  describe '.by_tag' do
    let!(:react) { create :page, tags: ['React', 'Front End'] }
    let!(:bem) { create :page, tags: ['Front End', 'CSS'] }

    it 'searches pages by tag' do
      expect(Page.by_tag('react')).to eq([react])
      expect(Page.by_tag('front-end')).to eq([react, bem])
    end
  end

  describe '.for_admin' do
    let!(:team) { create :page, url: '/team'}
    let!(:about_us) { create :page, url: '/about'}
    let!(:root_page) { create :page, url: '/'}
    let!(:deleted_page) { create :page, :deleted, url: '/zzz' }

    it 'displays all pages ordered by url' do
      expect(Page.for_admin).to eq([root_page, about_us, team])
    end

    it 'passes show option to actual' do
      expect(Page.for_admin('all')).to eq([root_page, about_us, team, deleted_page])
    end
  end

  describe '.blog' do
    let!(:first_blog_page) {
      create :page, :blog, url: '/blog/how-to-lisp',
                           created_at: 2.weeks.ago
    }
    let!(:second_blog_page) {
      create :page, :blog, url: '/blog/how-to-ocaml',
                           created_at: 1.week.ago
    }

    let!(:deleted_page) {
      create :page, :blog, :deleted, url: '/blog/how-to-clojure',
                           created_at: 1.week.ago
    }

    let!(:about_us) { create :page, url: '/about'}

    it 'displays all blog pages ordered by created at' do
      expect(Page.ordered_blog(:en)).to eq([second_blog_page, first_blog_page])
    end

    it 'does not display deleted pages' do
      expect(Page.blog(:en)).not_to include(:deleted_page)
    end
  end

  describe '.without' do
    let!(:first_page) { create :page }
    let!(:second_page) { create :page }

    it 'rejects provided page' do
      expect(Page.without(first_page)).to eq([second_page])
      expect(Page.without(second_page)).to eq([first_page])
    end
  end

  describe 'locale helpers' do
    describe '#translation' do
      let!(:ru_page) { create(:page, url: '/ru/test-lang') }
      let!(:en_page) { create(:page, url: '/test-lang') }

      it 'returns translated page for multilingual pages' do
        expect(ru_page.translation).to eq(en_page)
        expect(en_page.translation).to eq(ru_page)
      end

      it 'returns nil for single language pages' do
        page = create(:page, url: '/en/test-lang2')
        expect(page.translation).to eq(nil)
      end

      it 'checks full url without locale' do
        page = create(:page, url: '/test-lang2')
        create(:page, url: '/ru/blog/test-lang2')
        expect(page.translation).to eq(nil)
      end

      it 'it searches for published pages' do
        en_page.unpublish!

        expect(ru_page.translation).to eq(nil)
        expect(en_page.translation).to eq(ru_page)
      end

      it 'it searches for non deleted' do
        en_page.safe_delete

        expect(ru_page.translation).to eq(nil)
        expect(en_page.translation).to eq(ru_page)
      end
    end
  end

  describe 'safe deleting' do
    it_behaves_like 'safe deleting model' do
      let(:model_factory) { :page }
      let(:model_class) { Page }
    end
  end


  describe '#restore_to' do
    let!(:page) { create :page }

    it 'restores page to some version' do
      page.update_attributes title: 'Initial'
      page.update_attributes title: 'Changed'
      page.restore_to(page.versions.last)

      expect(page.reload.title).to eq('Initial')
    end

    it 'restores deletion status' do
      page.safe_delete
      page.restore_to(page.versions.last)

      expect(page.reload).not_to be_deleted
    end
  end

  describe "#related" do
    let!(:related_articles) { create_list :page, 5, :blog, tags: ['React', 'Ruby', 'Front End']}
    let!(:article) { create :page, :blog, tags: ['React', 'Front End', 'JS'] }

    it "returns 5 related published articles" do
      expect(article.related).to match_array(related_articles)
    end

    it "returns only 4 related published articles and not draft ones" do
      related_articles.last.unpublish!
      related_articles.pop
      expect(article.related).to match_array(related_articles)
    end

    it "returns Page.none if no tags" do
      article.tags = []
      expect(article.related).to be_empty
    end
  end

  describe 'workflow state machine' do
    it 'invokes #safe_delete on #safe_delete! event' do
      page = create :page
      page.safe_delete!

      expect(page).to be_deleted
      expect(page.current_state).to eq('safely_deleted')
    end

    it 'invokes #restore on #restore! event' do
      page = create :page, :deleted
      page.workflow_state = 'safely_deleted'
      page.restore!

      expect(page).not_to be_deleted
      expect(page.current_state).to eq('draft')
    end
  end
end
