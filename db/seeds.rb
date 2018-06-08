Product.create(
 brand: "Bledina",
 bar_code: "3041090030192",
 description: "",
 photo: "https://static.openfoodfacts.org/images/products/304/109/114/6939/front_fr.4.200.jpg",
 name: "Blediner - duo de carottes et patates douces semoule lait",
 source: "")

puts "produit créé"

Packaging.create(name: "barquette plastique", bin_id: 3, product_id: Product.last.id, material: nil)
Packaging.create(name: "couvercle plastique", bin_id: 3, product_id: Product.last.id, material: nil)
Packaging.create(name: "étui carton", bin_id: 1, product_id: Product.last.id, material: nil)
Packaging.create(name: "opercule métal", bin_id: 1, product_id: Product.last.id, material: nil)

puts "Packagings créés"
