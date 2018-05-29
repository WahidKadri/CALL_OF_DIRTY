require 'open-uri'
require 'json'

class ProductsController < ApplicationController

  def show
     @product = Product.find(params[:id])

  end

  def new
  end

  def create
    @bar_code = params[:product][:bar_code]
    @attributes = get_product_info(@bar_code)
    @product_scan = Product.new(@attributes)
    @product_scan.bar_code = @bar_code

    @sorting_hash = get_sorting_data(@product_scan)
    data = get_packaging_data(@product_scan)
    @bin = Bin.find()
    @product_scan.save
    Packaging.create(product: @product_scan, bin: @bin, )

    redirect_to product_path(@product_scan)
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def scan
    @product = Product.new
  end

  def get_product_info(bar_code)
    url = "https://fr.openfoodfacts.org/api/v0/produit/'#{bar_code}'.json"
    product_serialized = open(url).read
    parsed_product = JSON.parse(product_serialized)

    attribut = {
      name: parsed_product["product"]["product_name_fr"],
      brand: parsed_product["product"]["brands"],
      photo: parsed_product["product"]["image_front_small_url"],
      description: parsed_product["product"]["categories"],
     }
     return attribut
    end

  def get_sorting_data(product)
    url = "http://boxdataexchange.uzer.eu/apps/product.php?action=getDetailProduct&ean='#{product.bar_code}'&zipcode=78210"

    eugene_data_serialized = RestClient.get(url, headers={
      "Authorization" => ENV["EUGENE_SORTING_KEY"],
      "User-Agent" => "Dalvik/2.1.0 (Linux; U; Android 6.0; UMI_SUPER Build/MRA58K)",
      "Host" => "boxdataexchange.uzer.eu",
      "Connection" => "close",
      "Accept-Encoding" => "gzip, deflate"
      })

    parsed_eugene_data = JSON.parse(eugene_data_serialized)

    parsed_eugene_data.slice("recycle", "jette")
  end

  def get_packaging_data(product)
    url = "http://boxdataexchange.uzer.eu/apps/product.php?action=getPackagingsAndMaterialsPerProduct&ean='#{product.bar_code}'="

    eugene_data_serialized = RestClient.get(url, headers={
      "Authorization" => ENV["EUGENE_PACKAGING_KEY"],
      "User-Agent" => "Dalvik/2.1.0 (Linux; U; Android 6.0; UMI_SUPER Build/MRA58K)",
      "Host" => "boxdataexchange.uzer.eu",
      "Connection" => "close",
      "Accept-Encoding" => "gzip, deflate"
      })

    parsed_eugene_data = JSON.parse(eugene_data_serialized)

    # parsed_eugene_data.each do |packaging|
    #   @packaging_name = packaging["packaging_name"]
    #   @packaging_material = packaging["packaging_material"]
    # end
  end
end
