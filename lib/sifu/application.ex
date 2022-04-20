defmodule Sifu.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Workflow Engine
      {Workflow, [RVAT: Sifu.Workflow.RVAT.get_flow()]},
      # Start the Ecto repository
      Sifu.Repo,
      # Start the Telemetry supervisor
      SifuWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Sifu.PubSub},
      # Start the Endpoint (http/https)
      SifuWeb.Endpoint
      # Start a worker by calling: Sifu.Worker.start_link(arg)
      # {Sifu.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sifu.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SifuWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
