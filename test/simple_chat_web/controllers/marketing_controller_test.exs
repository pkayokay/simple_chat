defmodule SimpleChatWeb.MarketingControllerTest do
  use SimpleChatWeb.ConnCase

  import Inertia.Testing

  describe "index" do
    test "shows page", %{conn: conn} do
      conn = get(conn, ~p"/")
      html_response(conn, 200)
      assert inertia_component(conn) == "marketing/index"
      assert %{ssr: false} = inertia_props(conn)
    end
  end

  describe "about" do
    test "shows page", %{conn: conn} do
      conn = get(conn, ~p"/about")
      html_response(conn, 200)
      assert inertia_component(conn) == "marketing/about"
      assert %{ssr: false} = inertia_props(conn)
    end
  end

  describe "sign_in" do
    test "sets cookie and redirects to /rooms/new", %{conn: conn} do
      conn = post(conn, ~p"/sign_in", %{"nickname" => "testuser"})
      assert redirected_to(conn) == "/rooms/new"
    end
  end

  describe "log_out" do
    test "deletes cookie and redirects to /", %{conn: conn} do
      conn = delete(conn, ~p"/log_out")
      assert redirected_to(conn) == "/"
    end
  end
end
