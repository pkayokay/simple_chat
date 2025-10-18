defmodule SimpleChatWeb.Router do
  use SimpleChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimpleChatWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :browser_inertia do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {SimpleChatWeb.Layouts, :root_inertia}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SimpleChatWeb.Plugs.SetMetaUrl
    plug Inertia.Plug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SimpleChatWeb do
    pipe_through :browser

    get "/phoenix", PageController, :home
  end

  scope "/", SimpleChatWeb do
    pipe_through :browser_inertia

    get "/", MarketingController, :home
    get "/pricing", MarketingController, :pricing
  end

  scope "/app", SimpleChatWeb do
    pipe_through :browser_inertia

    get "/", AdminController, :dashboard
    get "/settings", AdminController, :settings
  end

  # Other scopes may use custom stacks.
  # scope "/api", SimpleChatWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:simple_chat, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: SimpleChatWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
