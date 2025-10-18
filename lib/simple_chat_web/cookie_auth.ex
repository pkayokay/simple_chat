defmodule SimpleChatWeb.CookieAuth do
  import Plug.Conn
  import Phoenix.Controller
  import Inertia.Controller

  @cookie_name "simple_chat_session"
  @redirect_path "/"

  # def init(opts), do: opts

  def redirect_if_no_cookie_user_nickname(conn, _opts) do
    conn = fetch_cookies(conn)

    if conn.cookies[@cookie_name] do
      conn
    else
      conn
      |> put_flash(:error, "Please set your nickname before continuing.")
      |> redirect(to: @redirect_path)
      |> halt()
    end
  end

  def set_cookie_user_nickname(conn, nickname) do
    two_weeks_in_seconds = 14 * 24 * 60 * 60

    put_resp_cookie(conn, @cookie_name, nickname,
      max_age: two_weeks_in_seconds,
      secure: true,
      same_site: "Lax"
    )
  end

  def delete_cookie_user_nickname(conn) do
    delete_resp_cookie(conn, @cookie_name)
  end

  def fetch_cookie_user_nickname(conn, _opts) do
    conn
    |> assign_prop(:cookie_user_nickname, conn.cookies[@cookie_name])
  end
end
