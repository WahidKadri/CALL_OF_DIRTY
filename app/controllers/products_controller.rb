require 'open-uri'
require 'json'

class ProductsController < ApplicationController

  def show
    # @product = Product.find(params[:id])
    # @bar_code = "8715700423913"
    # url = "https://fr.openfoodfacts.org/api/v0/produit/'#{@bar_code}'.json"
    # product_serialized = open(url).read
    # parsed_product = JSON.parse(product_serialized)
    # @name = parsed_product["product"]["product_name_fr"]
    # @brand = parsed_product["product"]["brands"]
    # @photo = parsed_product["product"]["image_front_small_url"]
    # @description = parsed_product["product"]["categories"]

    # Product.create(name: @brand, brand: @brand, photo: @photo, description: @description)
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def scan

  end
end
