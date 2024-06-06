defmodule ElixirKafka.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ElixirKafkaWeb.Telemetry,
      ElixirKafka.Repo,
      {DNSCluster, query: Application.get_env(:elixir_kafka, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ElixirKafka.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ElixirKafka.Finch},
      # Start a worker by calling: ElixirKafka.Worker.start_link(arg)
      # {ElixirKafka.Worker, arg},
      # Start to serve requests, typically the last entry
      ElixirKafkaWeb.Endpoint,
      {Task, fn -> start_brod_client() end},
      ElixirKafkaPubsub.Consumer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirKafka.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirKafkaWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp start_brod_client do
    :ok = :brod.start_client([{"localhost", 9092}], :kafka_client, auto_start_producers: true)
  end
end
