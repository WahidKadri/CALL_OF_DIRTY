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
    add_point_badge_scan

    redirect_to product_path(@product_scan)
  end

  def add_point_badge_scan
    # 2 badges
    # 2eme badge = paparrazzi
    @user_badge = UserBadge.where(user: current_user, badge: Badge.find(3)).first
    if @user_badge
      @user_badge.point += 1
      @user_badge.save
    else
      UserBadge.create(user: current_user, badge: Badge.find(3), point: 1)
    end

    @user_badge = UserBadge.where(user: current_user, badge: Badge.find(1)).first
    if @user_badge
      @user_badge.point += 1
      @user_badge.save
    else
      UserBadge.create(user: current_user, badge: Badge.find(1), point: 1)
    end
     # controle_badge

  end

  def controle_badge
    badges_to_controle = UserBadge.where(user: current_user)
    badges_to_controle.each do |user_badge|
      if user_badge.point > Badge.find_by(title: user_badge.badge.title).level
       # a =  UserBadge.find_by(badge: user_badge)
       user_badge.point = Badge.find_by(title: user_badge.badge.title).level
       user_badge.save
      end
    end
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

  def game_new
    @product = Product.find(params[:id])
    @packagings = Packaging.where(product: @product)
    @bin_quizz = Bin.new
    render :show
  end

  def game
    @point_game = 0
    @product = Product.find(params[:id])
    @binsquizz = params["/products/#{@product.id}"]
    @product.packagings.each do |packaging|
      if @binsquizz["#{packaging.name}"].to_i == packaging.bin.id
        @point_game += 1
      end
    end
    current_user.score += @point_game
    current_user.save

    @user_badge = UserBadge.where(user: current_user, badge: Badge.find(2)).first
    if @user_badge
      @user_badge.point += @point_game
      @user_badge.save
    else
      UserBadge.create(user: current_user, badge: Badge.find(2), point: @point_game)
    end
  end

  def game_solution
     @product = Product.find(params[:id])
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
