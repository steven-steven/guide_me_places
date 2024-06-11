// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// handle image errors
document.addEventListener("turbo:before-stream-render", function() {
  handleImageErrors();
});

function handleImageErrors() {
  const images = document.getElementsByClassName("article_img");
  if(!images || images.length <= 0) return

  for (const img of images) {
    img.onerror = function() {
      img.src = img.getAttribute("data-default");
    };
  }
}
