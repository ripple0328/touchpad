defmodule Touchpad.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Touchpad.Supervisor]

    # children =
      # [
      #   # Children for all targets
      #   # Starts a worker by calling: Touchpad.Worker.start_link(arg)
      #   # {Touchpad.Worker, arg},
      # ] ++ children(target())
    view_port = Application.get_env(:touchpad, :viewport)
    children = [
      {Scenic, [view_port]},
      Touchpad.PubSub.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end

  # List all child processes to be supervised
  def children(:host) do
      # Children that only run on the host
      # Starts a worker by calling: Touchpad.Worker.start_link(arg)
      # {Touchpad.Worker, arg},
  end

  def children(_target) do
    # Children for all targets except host
    # Starts a worker by calling: Touchpad.Worker.start_link(arg)
    # {Touchpad.Worker, arg},

  end

  def target() do
    Application.get_env(:touchpad, :target)
  end
end
