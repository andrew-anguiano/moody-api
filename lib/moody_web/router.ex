defmodule MoodyWeb.Router do
  use MoodyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", MoodyWeb do
    pipe_through :api
  end
end
