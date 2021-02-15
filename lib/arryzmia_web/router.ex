defmodule ArryzmiaWeb.Router do
  use ArryzmiaWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ArryzmiaWeb do
    pipe_through :api
  end
end
