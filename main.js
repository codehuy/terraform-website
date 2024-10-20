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


// view counters
const counter =  document.querySelector(".counter-number");
async function viewCounter() {
	// reference to lambda url
	let response = await fetch("https://lahdbwvkc2556rcb5wy7nktrwy0nflmu.lambda-url.us-east-1.on.aws/");
	let data = await response.json(); 
	counter.innerHTML = `Views: ${data}`;
}
viewCounter(); 

