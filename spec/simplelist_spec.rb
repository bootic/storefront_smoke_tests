require 'spec_helper'

site = ENV['TEST_HOST'] || 'http://simpleliststaging.bootic-shops.com'
describe site, type: :feature do
  before :all do
    Capybara.app_host = site
  end

  describe 'homepage' do
    before do
      visit '/'
    end

    it 'shows highlighted products' do
      within '#main' do
        expect(page).to have_content 'Productos destacados'
        expect(page).to have_content("XY Vision")
        expect(page).to have_content("Pony Blue")
        expect(page).to have_content("Stallion II")
      end
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
        expect(page).to have_product_image('staging.btcdn.co')
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
          expect(page).to have_content('(Default) XY Vision')
          expect(page).to have_content('$16.000')
        end
      end

      it 'can update quantity' do
        within '.ajax_cart ul.items li' do
          fill_in 'quantity', with: 2
          page.execute_script('$("input[name=quantity]").blur()') # blur
          expect(page).to have_content('$32.000')
        end
      end

      it 'can remove product from the cart' do
        within '.ajax_cart' do
          click_on '-'
          expect(page).not_to have_content('(Default) XY Vision')
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
      before do
        click_on 'Productos'
      end

      it 'lists products' do
        within '.products' do
          expect(page).to have_content 'Boomblock AB'
          expect(page).to have_content 'XY Vision'
          expect(page).to have_content 'Pony Blue'
          expect(page).to have_content 'Unicorn Flux'
          expect(page).to have_content 'Stallion II'
        end
      end

      describe 'filtering by tag' do
        it 'filters products' do
          within '.products' do
            click_on 'urban'
            expect(page).to have_content 'Unicorn Flux'
            expect(page).not_to have_content 'Pony Blue'
          end
        end
      end

      describe 'viewing product details' do
        before do
          within '.products .item-3' do
            click_on 'Pony Blue', match: :first
          end
        end

        it 'shows product info' do
          expect(page).to have_content 'Pony Blue'
          expect(page).to have_content '$120.000'
          expect(page).to have_content 'Este es un producto de ejemplo en Bootic.'
        end

        describe 'adding to cart' do
          before do
            within '.cart_and_price' do
              click_on 'Agregar al carro'
            end
          end

          it 'adds product to Ajax cart' do
            within '.ajax_cart' do
              expect(page).not_to have_content 'Carro vacío'
              expect(page).to have_content('(Default) Pony Blue')
              expect(page).to have_content('$120.000')
            end
          end

          describe 'checking out' do
            before do
              within '.ajax_cart' do
                click_on 'Comprar »'
              end
            end

            it 'shows checkout page' do
              expect(page).to have_content 'Simplelist'
              expect(page).to have_content 'Realizar nueva compra'
              expect(page).to have_content '$120.000'
              expect(page).to have_content 'Datos de contacto'
            end
          end
        end
      end
    end

    describe 'using forms' do
      before do
        click_on 'Contacto'
      end

      it 'shows form info' do
        expect(page).to have_content 'Ponte en contacto con nosotros. Te responderemos cuanto antes.'
      end

      describe 'validations' do
        it 'shows errors' do
          click_on 'Enviar!'
          expect(page).to have_content 'Formulario tiene errores'
        end
      end

      describe 'success' do
        before do
          fill_in 'Nombre y apellido', with: 'Foo Bar'
          fill_in 'Email', with: 'foo@bar.com'
          fill_in 'Teléfono', with: '1234567890'
          click_on 'Enviar!'
        end

        it 'sends the form and displays feedback' do
          expect(page).to have_content 'Mensaje enviado'
        end
      end
    end

    describe 'reading the blog' do
      before do
        click_on 'Blog'
      end

      it 'shows blog posts' do
        expect(page).to have_content 'Últimas noticias'
        expect(page).to have_link 'Primera noticia!'
        expect(page).to have_link 'Nuevos productos en catálogo'
      end

      describe 'reading a single post' do
        before do
          click_on 'Primera noticia!'
        end

        it 'shows blog post details' do
          expect(page).to have_content 'Ésta es la primera noticia publicada en tu tienda. Bórrala o edítala y continúa manteniendo el blog!'
          expect(page).not_to have_content 'Nuevos productos en catálogo'
        end
      end
    end

    describe 'searching' do
      before do
        fill_in 'q', with: 'pony'
        find('input[name=q]').native.send_keys(:return)
      end

      it 'shows results' do
        within '.products' do
          expect(page).to have_link 'Pony Blue'
          expect(page).not_to have_link 'XY Vision'
        end
      end
    end
  end
end
