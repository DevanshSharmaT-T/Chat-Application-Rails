import "@hotwired/turbo-rails"
import "controllers"
import { createConsumer } from "@rails/actioncable"
import jQuery from "jquery"
import "jquery_ujs"
import "emoji-mart"
import "timeago"
import "blueimp-gallery"

console.log("DEBUG: [application.js] Starting...");

// Initialize global objects early
window.jQuery = jQuery
window.$ = jQuery

try {
  window.cable = createConsumer();
  console.log("DEBUG: [application.js] window.cable initialized:", window.cable);
} catch (e) {
  console.error("DEBUG: [application.js] Failed to create consumer:", e);
}

console.log("DEBUG: [application.js] Finished loading.");
import "channels"


