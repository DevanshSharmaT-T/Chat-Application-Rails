import consumer from "channels/consumer"

let subscription

function subscribe(chatId) {
  if (subscription) {
    consumer.subscriptions.remove(subscription)
    subscription = null
  }

  subscription = consumer.subscriptions.create(
    { channel: "ChatChannel", chat_id: chatId },
    {
      connected() {
        console.log("DEBUG: [ActionCable] Connected to chat:", chatId);
      },
      received(data) {
        console.log("DEBUG: [ActionCable] Data received:", data);
        const $list = $('#messages-list');
        const $container = $('#messages-scroll-container');
        
        const $html = $(data.html);

        if (String(data.user_id) === String(window.currentUserId)) {
          const $bubbleContainer = $html.filter('div.flex');
          const $innerBubble = $html.find('.max-w-\\[75\\%\\]');

          $bubbleContainer.removeClass('justify-start').addClass('justify-end');
          $innerBubble.removeClass('bg-gray-800 text-gray-100 rounded-bl-md border border-gray-700')
                      .addClass('bg-blue-500 text-white rounded-br-md');
          $innerBubble.find('p.text-blue-400').remove(); // Hide name label for own messages
        }

        $list.append($html);
        if (window.timeago?.render) window.timeago.render(document.querySelectorAll(".timeago"));

        const isNearBottom = $container.prop('scrollHeight') - $container.scrollTop() - $container.outerHeight() < 200;
        if (isNearBottom || String(data.user_id) === String(window.currentUserId)) {
          $container.scrollTop($container.prop('scrollHeight'));
        }
      }
    }
  )
}

function send(chatId, body) {
  if (!subscription) return
  subscription.perform("speak", { chat_id: chatId, body })
}

window.ChatRealtime = { 
  subscribe: subscribe,
  send: send
};

console.log("DEBUG: [chat_channel.js] window.ChatRealtime initialized.");
export { subscribe, send }