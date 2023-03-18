defmodule NPlusOne.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    :ok = :telemetry.attach("n1-log", [:n_plus_one, :repo, :query], &NPlusOne.N1Check.Handler.handle_event/4, nil)

    children = [
      # Start the Telemetry supervisor
      NPlusOneWeb.Telemetry,
      # Start the Ecto repository
      NPlusOne.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NPlusOne.PubSub},
      # Start Finch
      {Finch, name: NPlusOne.Finch},
      # Start the Endpoint (http/https)
      NPlusOneWeb.Endpoint,
      # Start a worker by calling: NPlusOne.Worker.start_link(arg)
      {NPlusOne.N1Check.Detector, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NPlusOne.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NPlusOneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
