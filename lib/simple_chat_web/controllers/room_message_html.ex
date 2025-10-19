defmodule SimpleChatWeb.RoomMessageHTML do
  use SimpleChatWeb, :html

  embed_templates "room_message_html/*"

  @doc """
  Renders a room_message form.

  The form is defined in the template at
  room_message_html/room_message_form.html.heex
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true
  attr :return_to, :string, default: nil

  def room_message_form(assigns)
end
