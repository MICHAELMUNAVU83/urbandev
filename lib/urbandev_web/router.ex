defmodule UrbandevWeb.Router do
  use UrbandevWeb, :router

  import UrbandevWeb.UserAuth

  alias UrbandevWeb.EnsureRolePlug

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {UrbandevWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


   pipeline :user do
     plug EnsureRolePlug, ["admin", "user"]
   end

   pipeline :admin do
     plug EnsureRolePlug, "admin"
   end

  scope "/", UrbandevWeb do
    pipe_through [:browser, :fetch_current_user]
    live "/", PageLive, :index
    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm

    live "/acc", AccLive.Index, :index
    live "/acc/new", AccLive.Index, :new
    live "/acc/:id/edit", AccLive.Index, :edit
    live "/acc/:id", AccLive.Show, :show
    live "/acc/:id/show/edit", AccLive.Show, :edit
  end


  ## Authentication routes

  scope "/", UrbandevWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", UrbandevWeb do
    pipe_through [:browser, :require_authenticated_user, :user]
    live "/dashboard", DashboardLive, :index

    live "/cars", CarLive.Index, :index
   live "/cars/new", CarLive.Index, :new
   live "/cars/:id/edit", CarLive.Index, :edit
   live "/cars/:id", CarLive.Show, :show
   live "/cars/:id/show/edit", CarLive.Show, :edit




    live "/scans", ScanLive.Index, :index
    live "/scans/new", ScanLive.Index, :new
    live "/scans/:id/edit", ScanLive.Index, :edit
    live "/scans/:id", ScanLive.Show, :show
    live "/scans/:id/show/edit", ScanLive.Show, :edit



   live "/visitor", VisitorLive.Index, :index
    live "/visitor/new", VisitorLive.Index, :new
    live "/visitor/:id/edit", VisitorLive.Index, :edit
    live "/visitor/:id", VisitorLive.Show, :show
    live "/visitor/:id/show/edit", VisitorLive.Show, :edit



     live "/bills", BillLive.Index, :index
         live "/bills/new", BillLive.Index, :new
         live "/bills/:id/edit", BillLive.Index, :edit

         live "/bills/:id", BillLive.Show, :show
         live "/bills/:id/show/edit", BillLive.Show, :edit

           live "/users/:id", UserLive.Show, :show

    get "/users/fetch/settings", UserSettingsController, :edit
    put "/users/fetch/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
  end

  scope "/", UrbandevWeb do
    pipe_through [:browser, :require_authenticated_user, :admin]
    live "/residents", ResidentLive.Index, :index
    live "/residents/new", ResidentLive.Index, :new
    live "/residents/:id/edit", ResidentLive.Index, :edit
    live "/residents/:id", ResidentLive.Show, :show
    live "/residents/:id/show/edit", ResidentLive.Show, :edit

    live "/messages", MessageLive.Index, :index
    live "/messages/new", MessageLive.Index, :new
    live "/messages/:id", MessageLive.Show, :show

    live "/realestates", RealestateLive.Index, :index
    live "/realestates/new", RealestateLive.Index, :new
    live "/realestates/:id/edit", RealestateLive.Index, :edit
    live "/realestates/:id", RealestateLive.Show, :show
    live "/realestates/:id/show/edit", RealestateLive.Show, :edit

    live "/staff", StaffLive.Index, :index
    live "/staff/new", StaffLive.Index, :new
    live "/staff/:id/edit", StaffLive.Index, :edit
    live "/staff/:id", StaffLive.Show, :show
    live "/staff/:id/show/edit", StaffLive.Show, :edit




    live "/users", UserLive.Index, :index
    live "/users/new", UserLive.Index, :new
    live "/users/:id/edit", UserLive.Index, :edit
    live "/users/:id", UserLive.Show, :show
    live "/users/:id/show/edit", UserLive.Show, :edit


  end


  # Other scopes may use custom stacks.
  # scope "/api", UrbandevWeb do
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
      live_dashboard "/telemetric", metrics: UrbandevWeb.Telemetry
    end
  end

end
