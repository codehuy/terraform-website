jQuery(document).ready(function($) {

   if ($('.ds-testimonials-section').length) {
		$('.ds-testimonials-slider').slick({
		  	infinite: true,
		  	arrows: true,
		  	autoplay: true,
		  	autoplaySpeed: 4000,
		  	prevArrow:"<button type='button' class='slick-prev slick-arrow'><i class='ri-arrow-left-line'></i></button>",
		  	nextArrow:"<button type='button' class='slick-next slick-arrow'><i class='ri-arrow-right-line'></i></button>"
		});
    }
   

});


// View counters
const counter = document.querySelector(".counter-number");

async function viewCounter() {
  try {
    // Reference to lambda URL (ensure it starts with https://)
    let response = await fetch("https://t6ywcw3mt4pbfs5q4aluayn3xy0kqfpe.lambda-url.us-east-1.on.aws/");
    let data = await response.json();
    
    // Update counter with view count from data
    counter.innerHTML = `VIEWS: ${data.views}`;
  } catch (error) {
    console.error("Error fetching view count:", error);
    counter.innerHTML = "VIEWS: Error loading views";
  }
}

viewCounter();