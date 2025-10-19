defmodule SimpleChat.Repo.Migrations.CreateRoomMessages do
  use Ecto.Migration

  def change do
    create table(:room_messages) do
      add :user_id, :string
      add :user_nickname, :string
      add :content, :string
      add :room_id, references(:rooms, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end
  end
end
