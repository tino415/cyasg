defmodule Cyasg.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      CyasgWeb.Telemetry,
      Cyasg.Repo,
      {DNSCluster, query: Application.get_env(:cyasg, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Cyasg.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Cyasg.Finch},
      # Start a worker by calling: Cyasg.Worker.start_link(arg)
      # {Cyasg.Worker, arg},
      # Start to serve requests, typically the last entry
      CyasgWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Cyasg.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CyasgWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
