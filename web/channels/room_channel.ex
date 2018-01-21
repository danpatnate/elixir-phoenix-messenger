defmodule PhoenixChat.RoomChannel do
  require Logger
  use PhoenixChat.Web, :channel
  alias PhoenixChat.Presence

  def join("room:lobby", _, socket) do
    send self(), :after_join
    {:ok, socket}
  end

  def handle_info(:after_join, socket) do
    Presence.track(socket, socket.assigns.user, %{
      online_at: :os.system_time(:milli_seconds)
    })
    push socket, "presence_state", Presence.list(socket)
    {:noreply, socket}
  end

  def handle_in("message:new", message, socket) do
    broadcast! socket, "message:new", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end

  def handle_in("message:typing", message, socket) do
    broadcast! socket, "message:typing", %{
      user: socket.assigns.user,
      body: message,
      timestamp: :os.system_time(:milli_seconds)
    }
    {:noreply, socket}
  end

  # def handle_in("message:typing", %{"body" => body}, socket) do
  #   Logger.info  "Logging this text!"
  #   broadcast! socket, "message:typing", %{body: body}
  #   {:noreply, socket}
  # end

  # def handle_in("message:typing", socket) do
  #   # if !@typing do
  #     broadcast! socket, "message:typing", %{
  #       user: socket.assigns.user,
  #       body: @typing,
  #     }
  #     {:noreply, socket}
  #   # end
  # end
end
