defmodule SimpleChatWeb.MarketingController do
  use SimpleChatWeb, :controller

  def home(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("This is the marketing home page")
    |> assign_prop(:ssr, System.get_env("MIX_ENV") == "prod")
    |> render_inertia("marketing/home", ssr: System.get_env("MIX_ENV") == "prod")
  end

  def pricing(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("This is the marketing pricing page")
    |> assign_prop(:ssr, System.get_env("MIX_ENV") == "prod")
    |> render_inertia("marketing/pricing", ssr: System.get_env("MIX_ENV") == "prod")
  end
end
