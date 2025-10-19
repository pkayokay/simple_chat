defmodule SimpleChatWeb.RoomController do
  use SimpleChatWeb, :controller

  alias SimpleChat.Rooms
  alias SimpleChat.Rooms.Room
  alias SimpleChat.Repo

  def index(conn, _params) do
    rooms =
      Rooms.list_rooms()
      |> Enum.map(fn room ->
        room
        |> Map.from_struct()
        |> Map.drop([:__meta__, :room_messages])
      end)

    conn
    |> SimpleChatWeb.PageTitle.assign("Chat Rooms")
    |> assign_prop(:rooms, rooms)
    |> render_inertia("rooms/index")
  end

  def new(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("Create New Room")
    |> render_inertia("rooms/new")
  end

  def create(conn, %{"room" => room_params}) do
    slug = Nanoid.generate(10, "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
    room_params = Map.put(room_params, "slug", slug)

    case Rooms.create_room(room_params) do
      {:ok, room} ->
        conn
        |> json(%{
          success: true,
          room: %{id: room.id, name: room.name, slug: room.slug}
        })

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign_errors(changeset)
        |> json(%{success: false, errors: changeset})
    end
  end

  def show(conn, %{"slug" => slug}) do
    room =
      Rooms.get_room(slug)
      |> Repo.preload(:room_messages)

    room_messages =
      room.room_messages
      |> Enum.map(&(Map.from_struct(&1) |> Map.drop([:__meta__, :room])))

    case room do
      nil ->
        conn
        |> put_flash(:error, "Room not found.")
        |> redirect(to: ~p"/rooms")

      %Room{} = room ->
        conn
        |> SimpleChatWeb.PageTitle.assign(room.name)
        |> assign_prop(:room, %{id: room.id, name: room.name, slug: room.slug})
        |> assign_prop(:room_messages, room_messages)
        |> render_inertia("rooms/show")
    end
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Rooms.get_room!(id)

    case Rooms.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: ~p"/rooms/#{room.slug}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> assign_errors(changeset)
        |> redirect(to: ~p"/rooms/#{room.slug}")
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    {:ok, _room} = Rooms.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: ~p"/rooms")
  end
end
