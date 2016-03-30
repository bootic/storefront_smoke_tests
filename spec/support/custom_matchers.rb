RSpec::Matchers.define :have_product_image do |host|
  match do |actual|
    !!actual.find(:css, "img[src*='#{ host || 'http://r.btcdn.co' }']")
  end
end
