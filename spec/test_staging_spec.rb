require 'spec_helper'

site = ENV['TEST_HOST'] || 'http://test.bootic-shops.com'
describe site, type: :feature do
  before :all do
    Capybara.app_host = site
  end

  describe 'homepage' do
    before do
      visit '/'
    end

    it 'shows highlighted products' do
      within '#latest-products' do
        expect(page).to have_content("Los más vendidos")
        expect(page).to have_content("Boomblock AB")
        expect(page).to have_content("Unicorn Flux")
        expect(page).to have_content("Stallion II")
      end
    end

    it 'has main navigation' do
      expect(page).to have_link("Despachos")
      expect(page).to have_link("Contacto")
      expect(page).to have_link("Acerca de nosotros")
      expect(page).to have_link("Blog")
    end

    it 'has catalog links' do
      within '#shop-catalog' do
        expect(page).to have_link("Ofertas")
        expect(page).to have_link("Accesorios")
        expect(page).to have_link("Bicicletas")
        expect(page).to have_link("Destacados")
      end
    end
  end
end
