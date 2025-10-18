defmodule SimpleChatWeb.CookieAuthTest do
  use SimpleChatWeb.ConnCase

  alias SimpleChatWeb.CookieAuth

  @cookie_name "simple_chat_session"
  @signing_salt "Zk1l2OiwL-DEMO"

  describe "redirect_if_no_cookie_user_nickname/2" do
    test "allows connection to continue when valid nickname cookie exists", %{conn: conn} do
      # Set up a valid encrypted nickname cookie
      nickname = "test_user"
      encrypted_nickname = Phoenix.Token.encrypt(SimpleChatWeb.Endpoint, @signing_salt, nickname)

      conn =
        conn
        |> put_req_cookie(@cookie_name, encrypted_nickname)
        |> CookieAuth.redirect_if_no_cookie_user_nickname([])

      # Should not halt the connection
      refute conn.halted
    end

    test "redirects to home page when no cookie exists", %{conn: conn} do
      conn = CookieAuth.redirect_if_no_cookie_user_nickname(conn, [])

      # Should halt the connection and redirect
      assert conn.halted
      assert redirected_to(conn) == "/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "Please set your nickname before continuing."
    end

    test "redirects to home page when cookie contains invalid data", %{conn: conn} do
      # Set an invalid cookie value
      conn =
        conn
        |> put_req_cookie(@cookie_name, "invalid_encrypted_data")
        |> CookieAuth.redirect_if_no_cookie_user_nickname([])

      # Should halt the connection and redirect
      assert conn.halted
      assert redirected_to(conn) == "/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "Please set your nickname before continuing."
    end

    test "redirects to home page when cookie is empty string", %{conn: conn} do
      conn =
        conn
        |> put_req_cookie(@cookie_name, "")
        |> CookieAuth.redirect_if_no_cookie_user_nickname([])

      # Should halt the connection and redirect
      assert conn.halted
      assert redirected_to(conn) == "/"

      assert Phoenix.Flash.get(conn.assigns.flash, :error) ==
               "Please set your nickname before continuing."
    end
  end

  describe "set_cookie_user_nickname/2" do
    test "sets an encrypted nickname cookie in the response", %{conn: conn} do
      nickname = "test_user"

      conn = CookieAuth.set_cookie_user_nickname(conn, nickname)

      # Verify that the cookie is set in the response
      assert get_resp_cookie(conn, @cookie_name) != nil

      # Decrypt the cookie to verify its value
      encrypted_value = get_resp_cookie(conn, @cookie_name)

      {:ok, decrypted_nickname} =
        Phoenix.Token.decrypt(SimpleChatWeb.Endpoint, @signing_salt, encrypted_value)

      assert decrypted_nickname == nickname
    end
  end

  describe "delete_cookie_user_nickname/1" do
    test "deletes the nickname cookie from the response", %{conn: conn} do
      conn = CookieAuth.delete_cookie_user_nickname(conn)

      # Verify that the cookie is deleted in the response
      assert get_resp_cookie(conn, @cookie_name) == nil
    end
  end

  describe "fetch_cookie_user_nickname/2" do
    test "assigns the decrypted nickname when valid cookie exists", %{conn: conn} do
      nickname = "test_user"
      encrypted_nickname = Phoenix.Token.encrypt(SimpleChatWeb.Endpoint, @signing_salt, nickname)

      conn =
        conn
        |> put_req_cookie(@cookie_name, encrypted_nickname)
        |> CookieAuth.fetch_cookie_user_nickname([])

      assert conn.assigns.cookie_user_nickname == nickname
    end

    test "assigns nil when no cookie exists", %{conn: conn} do
      conn = CookieAuth.fetch_cookie_user_nickname(conn, [])

      assert conn.assigns.cookie_user_nickname == nil
    end

    test "assigns nil when cookie contains invalid data", %{conn: conn} do
      conn =
        conn
        |> put_req_cookie(@cookie_name, "invalid_encrypted_data")
        |> CookieAuth.fetch_cookie_user_nickname([])

      assert conn.assigns.cookie_user_nickname == nil
    end
  end

  describe "get_decrypted_nickname/1" do
    test "returns {:ok, nickname} for valid encrypted cookie", %{conn: conn} do
      nickname = "test_user"
      encrypted_nickname = Phoenix.Token.encrypt(SimpleChatWeb.Endpoint, @signing_salt, nickname)

      conn = put_req_cookie(conn, @cookie_name, encrypted_nickname)

      assert CookieAuth.get_decrypted_nickname(conn) == {:ok, nickname}
    end

    test "returns {:error, :no_cookie} when cookie is missing", %{conn: conn} do
      assert CookieAuth.get_decrypted_nickname(conn) == {:error, :no_cookie}
    end

    test "returns {:error, reason} for invalid encrypted cookie", %{conn: conn} do
      conn = put_req_cookie(conn, @cookie_name, "invalid_encrypted_data")

      assert {:error, _reason} = CookieAuth.get_decrypted_nickname(conn)
    end
  end
end
