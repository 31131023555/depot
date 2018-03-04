require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  fixtures :products

  test "product attributes must not be empty" do
  product = Product.new
  assert product.invalid?
  assert product.errors[:title].any?
  assert product.errors[:description].any?
  assert product.errors[:price].any?
  assert product.errors[:image_url].any?
  end

  test 'product price must be positive' do
    product = Product.new(title:       'Paladin outhere',
                          description: 'Say something here for Paladin',
                          image_url:   'st.jpg')
    product.price = -2
    assert product.invalid?
    assert.equal ['must be greater_than_or_equal_to 0.01'], product.errors[:price]

    product.price = 0
    assert product.invalid?
    assert.equal ['must be greater_than_or_equal_to 0.01'], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url) 
    Product.new(title:       'Paladin outhere',
                description: 'Say something here for Paladin',
                price:       2,
                image_url:   image_url)
  end

  test 'image_url' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
             http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ok.each do |name|
      assert new_product(name).valid?, "#{name} shouldn't be invalid"
    end

    bad.each do |name|
      assert new_product(name).invalid?, "#{name} shouldn't be valid"
    end
  end

  test 'product is not valid without a unique title' do
    product = Product.new(title:       products(:ruby).title,
                          description: 'zzz',
                          price:       2,
                          image_url:   'zzz.gif')
    assert product.invalid?
    assert_equal [I18n.translate('errors.messages.taken')], product.errors[:title]
  end
end
