defmodule MoodyWeb.Schema.Middleware.Authenticate do
  @behaviour Absinthe.Middleware

  # TODO: there's probably a way to refactor this so we don't have essentially
  # duplicated functions
  def call(resolution, :admin) do
    case resolution.context do
      %{current_user: %{role: "admin"}} -> resolution
      _ -> resolution
        |> Absinthe.Resolution.put_result(
          {:error, "You are unauthorized to view this resource."}
        )
    end
  end

  def call(resolution, _) do
    case resolution.context do
      %{current_user: _} -> resolution
      _ -> resolution
        |> Absinthe.Resolution.put_result(
          {:error, "You are unauthorized to view this resource."}
        )
    end
  end
end
