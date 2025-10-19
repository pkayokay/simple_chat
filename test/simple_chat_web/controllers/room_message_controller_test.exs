defmodule SimpleChatWeb.RoomMessageControllerTest do
  use SimpleChatWeb.ConnCase

  import SimpleChat.RoomsFixtures

  @create_attrs %{user_id: "some user_id", user_nickname: "some user_nickname", content: "some content"}
  @update_attrs %{user_id: "some updated user_id", user_nickname: "some updated user_nickname", content: "some updated content"}
  @invalid_attrs %{user_id: nil, user_nickname: nil, content: nil}

  describe "index" do
    test "lists all room_messages", %{conn: conn} do
      conn = get(conn, ~p"/room_messages")
      assert html_response(conn, 200) =~ "Listing Room messages"
    end
  end

  describe "new room_message" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/room_messages/new")
      assert html_response(conn, 200) =~ "New Room message"
    end
  end

  describe "create room_message" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/room_messages", room_message: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/room_messages/#{id}"

      conn = get(conn, ~p"/room_messages/#{id}")
      assert html_response(conn, 200) =~ "Room message #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/room_messages", room_message: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Room message"
    end
  end

  describe "edit room_message" do
    setup [:create_room_message]

    test "renders form for editing chosen room_message", %{conn: conn, room_message: room_message} do
      conn = get(conn, ~p"/room_messages/#{room_message}/edit")
      assert html_response(conn, 200) =~ "Edit Room message"
    end
  end

  describe "update room_message" do
    setup [:create_room_message]

    test "redirects when data is valid", %{conn: conn, room_message: room_message} do
      conn = put(conn, ~p"/room_messages/#{room_message}", room_message: @update_attrs)
      assert redirected_to(conn) == ~p"/room_messages/#{room_message}"

      conn = get(conn, ~p"/room_messages/#{room_message}")
      assert html_response(conn, 200) =~ "some updated user_id"
    end

    test "renders errors when data is invalid", %{conn: conn, room_message: room_message} do
      conn = put(conn, ~p"/room_messages/#{room_message}", room_message: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Room message"
    end
  end

  describe "delete room_message" do
    setup [:create_room_message]

    test "deletes chosen room_message", %{conn: conn, room_message: room_message} do
      conn = delete(conn, ~p"/room_messages/#{room_message}")
      assert redirected_to(conn) == ~p"/room_messages"

      assert_error_sent 404, fn ->
        get(conn, ~p"/room_messages/#{room_message}")
      end
    end
  end

  defp create_room_message(_) do
    room_message = room_message_fixture()

    %{room_message: room_message}
  end
end
