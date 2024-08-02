defmodule Quanda.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      QuandaWeb.Telemetry,
      Quanda.Repo,
      {DNSCluster, query: Application.get_env(:quanda, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Quanda.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Quanda.Finch},
      # Start a worker by calling: Quanda.Worker.start_link(arg)
      # {Quanda.Worker, arg},
      # Start to serve requests, typically the last entry
      QuandaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Quanda.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    QuandaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
