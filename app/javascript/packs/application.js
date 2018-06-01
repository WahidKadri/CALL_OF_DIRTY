import "bootstrap";
import Quagga from 'quagga'; // ES6

$(document).ready(function(){
  $(".category-choice").click(function(){
    $(this).toggleClass("active");
  });
});

Quagga.init({
  inputStream : {
    name : "Live",
    type : "LiveStream",
    target: document.querySelector('#barcode-scanner')    // Or '#yourElement' (optional)
  },
  decoder : {
    readers : ['ean_reader']
  }
}, function(err) {
  if (err) {
      console.log(err);
      return
  }
  console.log("Initialization finished. Ready to start");
  Quagga.start();
});

Quagga.onDetected(function(result) {
  const input = document.getElementById('product_bar_code');
  input.value = result.codeResult.code
  const form = document.getElementById('new_product')
  form.submit();
  Quagga.stop()
});


