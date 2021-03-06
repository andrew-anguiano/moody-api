defmodule MoodyWeb.Router do
  use MoodyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug MoodyWeb.Plugs.SetCurrentUser
  end

  scope "/" do
    pipe_through :api

    forward "/api", Absinthe.Plug,
      schema: MoodyWeb.Schema.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: MoodyWeb.Schema.Schema,
      socket: MoodyWeb.UserSocket
  end
end
