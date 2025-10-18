defmodule SimpleChatWeb.PageController do
  use SimpleChatWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
