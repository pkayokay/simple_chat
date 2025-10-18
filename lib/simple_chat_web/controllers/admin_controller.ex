defmodule SimpleChatWeb.AdminController do
  use SimpleChatWeb, :controller

  def dashboard(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("Dashboard")
    |> render_inertia("admin/dashboard")
  end

  def settings(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("Settings")
    |> render_inertia("admin/settings")
  end
end
