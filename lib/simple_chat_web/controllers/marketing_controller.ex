defmodule SimpleChatWeb.MarketingController do
  use SimpleChatWeb, :controller

  @ssr System.get_env("MIX_ENV") == "prod"

  def index(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("Simple Chat - Home")
    |> assign_prop(:ssr, @ssr)
    |> render_inertia("marketing/index", ssr: @ssr)
  end

  def about(conn, _params) do
    conn
    |> SimpleChatWeb.PageTitle.assign("Simple Chat - About")
    |> assign_prop(:ssr, @ssr)
    |> render_inertia("marketing/about", ssr: @ssr)
  end

  def sign_in(conn, params) do
    nickname = params["nickname"]

    redirect_to =
      case params["return_to"] do
        "" -> "/"
        nil -> "/"
        return_to -> return_to
      end

    conn
    |> SimpleChatWeb.CookieAuth.set_cookie_user_nickname(nickname)
    |> redirect(to: redirect_to)
  end

  def log_out(conn, _params) do
    conn
    |> SimpleChatWeb.CookieAuth.delete_cookie_user_nickname()
    |> redirect(to: "/")
  end
end
