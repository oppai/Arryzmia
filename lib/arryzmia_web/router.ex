defmodule ArryzmiaWeb.Router do
  use ArryzmiaWeb, :router

  pipeline :api do
    plug CORSPlug
    plug :accepts, ["json"]
  end

  scope "/api", ArryzmiaWeb do
    pipe_through :api
    scope "/dashboard", Controllers do
      get "/summary", DashboardController, :index
    end
  end
end
