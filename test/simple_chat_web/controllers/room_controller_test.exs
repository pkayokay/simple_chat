defmodule SimpleChatWeb.RoomControllerTest do
  use SimpleChatWeb.ConnCase

  import SimpleChat.RoomsFixtures
  import Inertia.Testing

  @create_attrs %{name: "some name", slug: "someslug"}
  @update_attrs %{name: "some updated name", slug: "someupdatedslug"}
  @invalid_attrs %{name: nil, slug: nil}

  setup do
    conn = SimpleChatWeb.CookieAuth.set_cookie_user_nickname(build_conn(), "TestUser")
    %{conn: conn}
  end

  describe "index" do
    setup [:create_room]

    test "lists all rooms", %{conn: conn} do
      conn = get(conn, ~p"/rooms")
      html_response(conn, 200)
      assert inertia_component(conn) == "rooms/index"
    end
  end

  describe "new room" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/rooms/new")
      assert inertia_component(conn) == "rooms/new"
    end
  end

  describe "create room" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/rooms", room: @create_attrs)

      assert %{slug: slug} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/rooms/#{slug}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/rooms", room: @invalid_attrs)
      assert redirected_to(conn) == ~p"/rooms/new"
    end
  end

  describe "show" do
    setup [:create_room]

    test "shows room", %{conn: conn, room: room} do
      conn = get(conn, ~p"/rooms/#{room.slug}")
      assert inertia_component(conn) == "rooms/show"
    end

    test "redirects when room not found", %{conn: conn} do
      conn = get(conn, ~p"/rooms/nonexistent-slug")
      assert redirected_to(conn) == ~p"/rooms"
      assert Phoenix.Flash.get(conn.assigns.flash, :error) =~ "Room not found."
    end
  end

  describe "update room" do
    setup [:create_room]

    test "redirects when data is valid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/rooms/#{room}", room: @update_attrs)
      assert redirected_to(conn) == ~p"/rooms/#{@update_attrs.slug}"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Room updated successfully."
    end

    test "renders errors when data is invalid", %{conn: conn, room: room} do
      conn = put(conn, ~p"/rooms/#{room}", room: @invalid_attrs)
      assert redirected_to(conn) == ~p"/rooms/#{room.slug}"
      assert inertia_errors(conn) == %{name: "can't be blank", slug: "can't be blank"}
    end
  end

  describe "delete room" do
    setup [:create_room]

    test "deletes chosen room", %{conn: conn, room: room} do
      conn = delete(conn, ~p"/rooms/#{room}")
      assert redirected_to(conn) == ~p"/rooms"
      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~ "Room deleted successfully."
    end
  end

  defp create_room(_) do
    room = room_fixture()

    %{room: room}
  end
end
