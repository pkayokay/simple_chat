defmodule SimpleChatWeb.RoomChannel do
  use SimpleChatWeb, :channel
  alias SimpleChatWeb.Presence

  @impl true
  def join("room:" <> slug, %{"nickname" => nickname, "id" => id}, socket) do
    socket =
      socket
      |> assign(:room_slug, slug)
      |> assign(:nickname, nickname)
      |> assign(:id, id)

    send(self(), :after_join)
    {:ok, socket}
  end

  @impl true
  def handle_info(:after_join, socket) do
    user_key = "#{socket.assigns.nickname}-#{socket.assigns.id}"

    {:ok, _} =
      Presence.track(socket, user_key, %{
        nickname: socket.assigns.nickname,
        id: socket.assigns.id
      })

    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end
end
