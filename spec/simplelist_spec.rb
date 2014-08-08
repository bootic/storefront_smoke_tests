require 'spec_helper'

describe 'simplelist.bootic.dev', type: :feature do
  before :all do
    Capybara.app_host = 'http://simplelist.bootic.dev'
  end


  describe 'homepage' do
    before do
      visit '/'
    end

    it 'shows highlighted products' do
      expect(page).to have_content("Pony Blue")
      expect(page).to have_content("Buzzy")
      expect(page).to have_content("Stallion II")
      expect(page).to have_content("Lightrek")
      expect(page).to have_content("Este es un producto de ejemplo en Bootic")
    end

    it 'has main navigation' do
      expect(page).to have_link("Despachos")
      expect(page).to have_link("Contacto")
      expect(page).to have_link("Acerca de nosotros")
      expect(page).to have_link("Productos")
      expect(page).to have_link("Blog")
    end

    it 'has catalog links' do
      expect(page).to have_content('Catálogo de productos')
      expect(page).to have_link("Accesorios")
      expect(page).to have_link("Bicicletas")
      expect(page).to have_link("Destacados")
      expect(page).to have_link("Ofertas")
    end

    it 'has product images' do
      within '.products .item-1' do
        expect(page).to have_product_image
      end
    end
    it 'starts with an empty cart' do
      within '.ajax_cart' do
        expect(page).to have_content 'Carro vacío'
      end
    end

    describe 'managing the Ajax cart' do
      before do
        within '.products .item-1' do
          click_on 'Agregar al carro'
        end
      end

      it 'adds product to the cart' do
        within '.ajax_cart' do
          expect(page).not_to have_content 'Carro vacío'
          expect(page).to have_content('(Default) Pony Blue')
          expect(page).to have_content('$120.000')
        end
      end

      it 'can update quantity' do
        within '.ajax_cart ul.items li' do
          fill_in 'quantity', with: 2
          page.execute_script('$("input[name=quantity]").blur()') # blur
          expect(page).to have_content('$240.000')
        end
      end

      it 'can remove product from the cart' do
        within '.ajax_cart' do
          click_on '-'
          expect(page).not_to have_content('(Default) Pony Blue')
        end
      end
    end

    describe 'visiting pages' do
      before do
        click_on 'Despachos'
      end

      it 'shows page content' do
        expect(page).to have_content 'Despachos'
        expect(page).to have_content "Información sobre despachos y devoluciones de tus productos"
      end

    end

    describe 'listing all products' do

      describe 'viewing product details' do

      end
    end

    describe 'using forms' do

    end

    describe 'reading the blog' do

      describe 'reading a single post' do

      end
    end
  end
end
