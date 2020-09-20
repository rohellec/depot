require 'rails_helper'

describe Product do
  fixtures :products

  let(:product) { Product.new(title: "Lorem Ipsum",
                              description: "Wibbles are fun!",
                              image_url: "lorem.jpg",
                              price: 19.95) }
  describe "validations" do

    context("invalid") do
      let(:empty_product) { Product.new }

      it "if attrs are empty" do
        expect(empty_product).to be_invalid
        [:title, :description, :price, :image_url].each do |key|
          expect(empty_product.errors[key]).not_to be_empty
        end
      end

      it "if price is negative" do
        product.price = -1
        expect(product).to be_invalid
        expect(product.errors[:price]).not_to be_empty
      end

      it "if price equals to 0" do
        product.price = 0
        expect(product).to be_invalid
        expect(product.errors[:price]).not_to be_empty
      end

      it "if image url has incorrect format" do
        failed_urls = %w[fred.doc fred.gif/more fred.jpg.more]
        failed_urls.each do |url|
          product.image_url = url
          expect(product).to be_invalid
          expect(product.errors[:image_url]).not_to be_empty
        end
      end

      it "if title is not a unique" do
        product.title = products(:ruby).title
        expect(product).to be_invalid
        expect(product.errors[:title]).not_to be_empty
      end

      it "if title's length < 10 symbols" do
        product.title = "invalid"
        expect(product).to be_invalid
        expect(product.errors[:title]).not_to be_empty
      end
    end

    context("valid") do
      it "if price is >= 0.01" do
        product.price = 0.01
        expect(product).to be_valid
        expect(product.errors[:price]).to be_empty
      end

      it "if image url has incorrect format" do
        passed_urls = %w[fred.gif fred.jpeg fred.png FRED.JPG FRED.Jpg
                         http://a.b.c/x/y/z/fred.gif]
        passed_urls.each do |url|
          product.image_url = url
          expect(product).to be_valid
        end
      end
    end
  end
end
