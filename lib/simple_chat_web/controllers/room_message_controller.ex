defmodule SimpleChatWeb.RoomMessageController do
  use SimpleChatWeb, :controller

  alias SimpleChat.Rooms
  alias SimpleChat.Rooms.RoomMessage

  def index(conn, _params) do
    room_messages = Rooms.list_room_messages()
    render(conn, :index, room_messages: room_messages)
  end

  def new(conn, _params) do
    changeset = Rooms.change_room_message(%RoomMessage{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"room_message" => room_message_params}) do
    room = Rooms.get_room!(room_message_params["room_id"])

    case Rooms.create_room_message(room_message_params) do
      {:ok, room_message} ->
        conn
        |> redirect(to: ~p"/rooms/#{room.slug}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_flash(
          :error,
          changeset.errors |> Enum.map_join(", ", fn {k, {v, _}} -> "#{k} #{v}" end)
        )
        |> redirect(to: ~p"/rooms/#{room.slug}")
    end
  end

  def show(conn, %{"id" => id}) do
    room_message = Rooms.get_room_message!(id)
    render(conn, :show, room_message: room_message)
  end

  def edit(conn, %{"id" => id}) do
    room_message = Rooms.get_room_message!(id)
    changeset = Rooms.change_room_message(room_message)
    render(conn, :edit, room_message: room_message, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room_message" => room_message_params}) do
    room_message = Rooms.get_room_message!(id)

    case Rooms.update_room_message(room_message, room_message_params) do
      {:ok, room_message} ->
        conn
        |> put_flash(:info, "Room message updated successfully.")
        |> redirect(to: ~p"/room_messages/#{room_message}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, room_message: room_message, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room_message = Rooms.get_room_message!(id)
    {:ok, _room_message} = Rooms.delete_room_message(room_message)

    conn
    |> put_flash(:info, "Room message deleted successfully.")
    |> redirect(to: ~p"/room_messages")
  end
end
