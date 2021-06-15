defmodule SamsonEnMarieWeb.Router do
  use SamsonEnMarieWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug SamsonEnMarieWeb.Plugs.Locale
  end

  pipeline :allowed_for_users do
    plug SamsonEnMarieWeb.Plugs.AuthorizationPlug, ["Admin", "Geregistreerde gebruiker", "Gast"]
  end

  pipeline :allowed_for_managers do
    plug SamsonEnMarieWeb.Plugs.AuthorizationPlug, ["Admin", "Geregistreerde gebruiker"]
  end

  pipeline :allowed_for_admins do
    plug SamsonEnMarieWeb.Plugs.AuthorizationPlug, ["Admin"]
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug SamsonEnMarieWeb.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  if Mix.env == :dev do
    # If using Phoenix
    forward "/sent_emails", Bamboo.EmailPreviewPlug
  end

  scope "/", SamsonEnMarieWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    resources "/email-verification", EmailVerificationController, except: [:index, :show]
    post "/email-verification/:verification_token",EmailVerificationController, :update
    get "/register", UserController, :new
    post "/register", UserController, :create
    get "/login", SessionController, :new
    post "/login", SessionController, :login
    get "/logout", SessionController, :logout
    get "/products", ProductsController, :index_user
    get "/products/:id", ProductsController, :show_user
    post "/show_minimum_prijs", ProductsController, :show_minimum_prijs
    post "/show_maximum_prijs", ProductsController, :show_maximum_prijs
    post "/show_naam" , ProductsController, :show_naam
    post "/show_maat" , ProductsController, :show_maat
    post "/show_kleur" , ProductsController, :show_kleur
  end

  scope "/", SamsonEnMarieWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_users]
    get "/users/show", UserController,:show_jezelf
    put "/edit_profiel", UserController, :edit_profiel
    get "/edit_profiel", UserController, :get_edit_profiel
    get "/user_scope", PageController, :user_index
    get "/add_to_cart", WinkelkarController, :add_to_cart
    post "/betalen", WinkelkarController, :betalen
    get "/betalen", WinkelkarController, :betalen
    post "/delete_product", WinkelkarController, :delete_product
    get "/history", UserController, :history
  end


  scope "/admin", SamsonEnMarieWeb do
    pipe_through [:browser, :auth, :ensure_auth, :allowed_for_admins]

    post "/valideer", UserController, :validate_manueel
    get "/valideer", UserController, :validate_manueel
    resources "/users", UserController
    post "/products", ProductsController, :create
    post "/products_file", ProductsController, :create_file

    resources "/products", ProductsController
    get "/", PageController, :admin_index
    get "/key", UserController, :create_key

  end

  scope "/api", SamsonEnMarieWeb.Api do
    pipe_through :api

    resources "/products", ProductsController, only: [:show, :index]

  end

  scope "/api_admin", SamsonEnMarieWeb.Api do
    pipe_through :api

    resources "/users", UserController, only: [:index]
    get "/users/:id", UserController, :history

  end
  # Other scopes may use custom stacks.
  # scope "/api", SamsonEnMarieWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: SamsonEnMarieWeb.Telemetry
    end
  end
end
