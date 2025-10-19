defmodule SimpleChat.Rooms.RoomMessage do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_messages" do
    field :user_id, :string
    field :user_nickname, :string
    field :content, :string

    belongs_to :room, SimpleChat.Rooms.Room
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room_message, attrs) do
    room_message
    |> cast(attrs, [:user_id, :user_nickname, :content, :room_id])
    |> validate_required([:user_id, :user_nickname, :content, :room_id])
  end
end
