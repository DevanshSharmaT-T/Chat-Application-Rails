import { createConsumer } from "@rails/actioncable"

console.log("DEBUG: [consumer.js] Initializing...");

if (!window.cable) {
  window.cable = createConsumer();
}

const consumer = window.cable
export default consumer