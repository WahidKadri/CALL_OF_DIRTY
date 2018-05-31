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
    if Product.where(bar_code: @bar_code).exists?
      @product_scan = Product.find_by(bar_code: @bar_code)
    else
      @attributes = get_product_info(@bar_code)
      if @attributes.nil?
        redirect_to scan_product_path, alert: "Please scan again"
        return
      end
      @product_scan = Product.new(@attributes)
      @product_scan.bar_code = @bar_code
      @product_scan.save

      data = get_packaging_data(@product_scan)
      @sorting_hash = get_sorting_data(@product_scan)
      data.each do |packaging|
        if @sorting_hash["jette"].downcase.include?(packaging)
          @bin = Bin.find_by(color: "vert")
        elsif @sorting_hash["recycle"].downcase.include?("verre")
          @bin = Bin.find_by(color: "blanc")
        else
          @bin = Bin.find_by(color: "jaune")
        end

        Packaging.create(name: packaging, product: @product_scan, bin: @bin)
      end
    end
    Scan.create(user: current_user, product: @product_scan)
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
    return nil if parsed_product["status_verbose"] == "product not found"

    attribut = {
      name: parsed_product["product"]["product_name_fr"],
      brand: parsed_product["product"]["brands"],
      photo: parsed_product["product"]["image_front_small_url"],
      description: parsed_product["product"]["categories"],
     }
     return attribut
    end

  def get_sorting_data(product)
    url = "http://boxdataexchange.uzer.eu/apps/product.php?action=getDetailProduct&coord=&ean=#{product.bar_code}&scan=1&$zipcode=78210"

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
    url = "http://boxdataexchange.uzer.eu/apps/product.php?action=getPackagingsAndMaterialsPerProduct&ean=#{product.bar_code}&2="

    eugene_data_serialized = RestClient.get(url, headers={
      "Authorization" => ENV["EUGENE_PACKAGING_KEY"],
      "User-Agent" => "Dalvik/2.1.0 (Linux; U; Android 6.0; UMI_SUPER Build/MRA58K)",
      "Host" => "boxdataexchange.uzer.eu",
      "Connection" => "close",
      "Accept-Encoding" => "gzip, deflate"
      })

    parsed_eugene_data = JSON.parse(eugene_data_serialized)

    packagings_product = []
    parsed_eugene_data.each do |packaging|
      @packaging_name = packaging["packaging_name"]
      @packaging_material = packaging["packaging_material"]
      packagings_product << @packaging_name.downcase + " " + @packaging_material.downcase
    end
    return packagings_product
  end
end
