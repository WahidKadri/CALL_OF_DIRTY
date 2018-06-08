function addBorderToButton() {
  const buttons = document.querySelectorAll(".form-check");
  // console.log(buttons);
  buttons.forEach(function(button) {
    button.addEventListener("click", event => {
      // buttons.forEach(function(btn) {
      //   btn.
      // })
      const fieldset = event.currentTarget.closest("fieldset");
      const formButtons = fieldset.querySelectorAll(".form-check");
      formButtons.forEach(function(btn) {
        btn.classList.remove("circle-border");
      })
      event.currentTarget.classList.toggle("circle-border");
    });
  });
}

export { addBorderToButton };
