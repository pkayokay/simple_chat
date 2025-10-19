defmodule SimpleChat.RoomsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SimpleChat.Rooms` context.
  """

  @doc """
  Generate a room.
  """
  def room_fixture(attrs \\ %{}) do
    {:ok, room} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "someslug"
      })
      |> SimpleChat.Rooms.create_room()

    room
  end

  @doc """
  Generate a room_message.
  """
  def room_message_fixture(attrs \\ %{}) do
    {:ok, room_message} =
      attrs
      |> Enum.into(%{
        content: "some content",
        user_id: "some user_id",
        user_nickname: "some user_nickname"
      })
      |> SimpleChat.Rooms.create_room_message()

    room_message
  end
end
