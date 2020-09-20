require "rails_helper"

describe ProductsController do
  fixtures :products

  let(:product) { products(:one) }
  let(:product_attrs) do
    {
      "title" => "Lorem Ipsum",
      "description" => "Wibbles are fun!",
      "image_url" => "lorem.jpg",
      "price" => 19.95
    }
  end

  describe "get :index" do
    before { get :index }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it "assigns products list to @products" do
      products.each do |product|
        expect(assigns(:products)).to include(product)
      end
    end
  end

  describe "get :show" do
    before { get :show, params: { id: product.id } }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(assigns(:product)).to eq(product) }
  end

  describe "get :new" do
    before { get :new }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
    it { expect(assigns(:product)).to be_a_new(Product) }
  end

  describe "post :create" do
    let(:last_product) { Product.last }

    before { post :create, params: { product: product_attrs } }

    it { expect(response).to redirect_to(last_product) }

    it "creates product with attrs equal to params" do
      last_product.reload
      expect(last_product.attributes).to include(product_attrs)
    end

    it "increases products count" do
      expect { post :create, params: { product: product_attrs } }
        .to change(Product, :count).by(1)
    end
  end

  describe "patch :update" do
    before { patch :update, params: { id: product, product: product_attrs } }

    it { expect(response).to redirect_to(product) }

    it "update product's attrs with requested params" do
      product.reload
      expect(product.attributes).to include(product_attrs)
    end
  end

  describe "delete :destroy" do
    it "deletes product from database" do
      expect { delete :destroy, params: { id: product } }
        .to change(Product, :count).by(-1)
    end

    it "redirects to products page" do
      delete :destroy, params: { id: product }
      expect(response).to redirect_to(products_url)
    end
  end
end
