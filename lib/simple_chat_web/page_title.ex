defmodule SimpleChatWeb.PageTitle do
  use SimpleChatWeb, :controller

  def assign(conn, title) do
    conn
    |> assign(:page_title, title)
    |> assign_prop(:page_title, title)
  end
end
