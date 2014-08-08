RSpec::Matchers.define :have_product_image do
  match do |actual|
    !!actual.find(:css, "img[src*='http://r.btcdn.co']")
  end
end
