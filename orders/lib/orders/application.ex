defmodule Orders.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      OrdersWeb.Telemetry,
      # Start the Ecto repository
      Orders.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Orders.PubSub},
      # Start Finch
      {Finch, name: Orders.Finch},
      # Start the Endpoint (http/https)
      OrdersWeb.Endpoint,
      Orders.SQS.RestaurantConsumer
      # Start a worker by calling: Orders.Worker.start_link(arg)
      # {Orders.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Orders.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    OrdersWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
