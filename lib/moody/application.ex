defmodule Moody.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Moody.Repo,
      # Start the endpoint when the application starts
      MoodyWeb.Endpoint
      # Starts a worker by calling: Moody.Worker.start_link(arg)
      # {Moody.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Moody.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MoodyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
