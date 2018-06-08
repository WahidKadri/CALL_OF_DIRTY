import "bootstrap";
import { addBorderToButton } from "../components/add_border_to_button.js";
// import "modal";
import {showModal} from "../components/show_modal.js";
import Quagga from 'quagga'; // ES6
addBorderToButton();

addBorderToButton();

global.showModal = showModal;

$(document).ready(function(){
  $(".category-choice").click(function(){
    $(this).toggleClass("active");
  });

  // IMAGE OPACITY - HOME
  Array.from(document.querySelectorAll('.progress-bar')).forEach(function(bar){
    if (bar.getAttribute('aria-valuenow') == 100) {
      const badge = bar.parentNode.parentNode.parentNode;
      badge.querySelector('img').classList.add('complete');
    };
  });
});

if (document.querySelector('#barcode-scanner')){
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
       return
   }
   Quagga.start();
  });
}

 Quagga.onDetected(function(result) {
   const input = document.getElementById('product_bar_code');
   input.value = result.codeResult.code
   const form = document.getElementById('new_product')
   form.submit();
   Quagga.stop()
 });
