import consumer from "channels/consumer"

let subscription

function htmlEscape(text) {
  return String(text)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll("\"", "&quot;")
    .replaceAll("'", "&#39;")
}

function messageHtml(data) {
  const mine = String(data.user_id) === String(window.currentUserId)
  const sender = !mine && window.activeChatType === "Group"
    ? `<p class="text-[10px] text-blue-400 mb-1">${htmlEscape(data.user_name)}</p>`
    : ""

  return `
    <div class="flex ${mine ? "justify-end" : "justify-start"} message-item" data-message-id="${data.id}">
      <div class="${mine ? "bg-blue-600 text-white" : "bg-gray-900 border border-gray-800 text-gray-200"} rounded-xl px-3 py-2 max-w-[75%]">
        ${sender}
        <p class="text-sm break-words">${htmlEscape(data.body)}</p>
        <p class="text-[10px] opacity-70 mt-1 timeago" datetime="${data.created_at}">${data.created_at}</p>
      </div>
    </div>
  `
}

function subscribe(chatId) {
  if (subscription) subscription.unsubscribe()

  subscription = consumer.subscriptions.create(
    { channel: "ChatChannel", chat_id: chatId },
    {
      received(data) {
        $("#messages-list").append(messageHtml(data))
        if (window.timeago?.render) window.timeago.render(document.querySelectorAll(".timeago"))
        const container = $("#messages-scroll-container")
        container.scrollTop(container.prop("scrollHeight"))
      }
    }
  )
}

function send(chatId, body) {
  if (!subscription) return
  subscription.perform("speak", { chat_id: chatId, body })
}

window.ChatRealtime = { subscribe, send }
