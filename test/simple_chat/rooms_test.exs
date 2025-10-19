defmodule SimpleChat.RoomsTest do
  use SimpleChat.DataCase

  alias SimpleChat.Rooms

  describe "rooms" do
    alias SimpleChat.Rooms.Room

    import SimpleChat.RoomsFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Room{} = room} = Rooms.create_room(valid_attrs)
      assert room.name == "some name"
      assert room.slug == "some slug"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Room{} = room} = Rooms.update_room(room, update_attrs)
      assert room.name == "some updated name"
      assert room.slug == "some updated slug"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end

  describe "room_messages" do
    alias SimpleChat.Rooms.RoomMessage

    import SimpleChat.RoomsFixtures

    @invalid_attrs %{user_id: nil, user_nickname: nil, content: nil}

    test "list_room_messages/0 returns all room_messages" do
      room_message = room_message_fixture()
      assert Rooms.list_room_messages() == [room_message]
    end

    test "get_room_message!/1 returns the room_message with given id" do
      room_message = room_message_fixture()
      assert Rooms.get_room_message!(room_message.id) == room_message
    end

    test "create_room_message/1 with valid data creates a room_message" do
      valid_attrs = %{user_id: "some user_id", user_nickname: "some user_nickname", content: "some content"}

      assert {:ok, %RoomMessage{} = room_message} = Rooms.create_room_message(valid_attrs)
      assert room_message.user_id == "some user_id"
      assert room_message.user_nickname == "some user_nickname"
      assert room_message.content == "some content"
    end

    test "create_room_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room_message(@invalid_attrs)
    end

    test "update_room_message/2 with valid data updates the room_message" do
      room_message = room_message_fixture()
      update_attrs = %{user_id: "some updated user_id", user_nickname: "some updated user_nickname", content: "some updated content"}

      assert {:ok, %RoomMessage{} = room_message} = Rooms.update_room_message(room_message, update_attrs)
      assert room_message.user_id == "some updated user_id"
      assert room_message.user_nickname == "some updated user_nickname"
      assert room_message.content == "some updated content"
    end

    test "update_room_message/2 with invalid data returns error changeset" do
      room_message = room_message_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room_message(room_message, @invalid_attrs)
      assert room_message == Rooms.get_room_message!(room_message.id)
    end

    test "delete_room_message/1 deletes the room_message" do
      room_message = room_message_fixture()
      assert {:ok, %RoomMessage{}} = Rooms.delete_room_message(room_message)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room_message!(room_message.id) end
    end

    test "change_room_message/1 returns a room_message changeset" do
      room_message = room_message_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room_message(room_message)
    end
  end
end
