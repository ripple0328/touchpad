defmodule Touchpad do
  @moduledoc """
  Documentation for Touchpad.
  """

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
end
