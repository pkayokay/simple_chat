defmodule SimpleChatWeb.CookieAuth do
  import Plug.Conn
  import Phoenix.Controller
  import Inertia.Controller

  @cookie_name "simple_chat_session"
  @redirect_path "/"
  @signing_salt "Zk1l2OiwL-DEMO"

  def redirect_if_no_cookie_user_nickname(conn, _opts) do
    conn = fetch_cookies(conn)

    case get_decrypted_nickname(conn) do
      {:ok, _nickname} ->
        conn

      {:error, _reason} ->
        return_to =
          case conn.query_string do
            "" -> conn.request_path
            qs -> conn.request_path <> "?" <> qs
          end
          |> URI.encode_www_form()

        conn
        |> put_flash(:error, "Please set your nickname before continuing.")
        |> redirect(to: "#{@redirect_path}?return_to=#{return_to}")
        |> halt()
    end
  end

  def set_cookie_user_nickname(conn, nickname) do
    two_weeks_in_seconds = 14 * 24 * 60 * 60

    # Encrypt the nickname using the signing salt
    encrypted_nickname =
      Phoenix.Token.encrypt(SimpleChatWeb.Endpoint, @signing_salt, %{
        nickname: nickname,
        id: Nanoid.generate(10)
      })

    put_resp_cookie(conn, @cookie_name, encrypted_nickname,
      max_age: two_weeks_in_seconds,
      secure: true,
      same_site: "Lax"
    )
  end

  def delete_cookie_user_nickname(conn) do
    delete_resp_cookie(conn, @cookie_name)
  end

  def fetch_cookie_user_nickname(conn, _opts) do
    case get_decrypted_nickname(conn) do
      {:ok, %{nickname: nickname, id: id}} ->
        assign_prop(conn, :current_user, %{nickname: nickname, id: id})

      {:error, _reason} ->
        assign_prop(conn, :current_user, nil)
    end
  end

  # Helper function to decrypt the nickname from the cookie
  defp get_decrypted_nickname(conn) do
    with encrypted_value when not is_nil(encrypted_value) <- conn.cookies[@cookie_name],
         {:ok, nickname} <-
           Phoenix.Token.decrypt(SimpleChatWeb.Endpoint, @signing_salt, encrypted_value) do
      {:ok, nickname}
    else
      nil -> {:error, :no_cookie}
      {:error, reason} -> {:error, reason}
    end
  end
end
