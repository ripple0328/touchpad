defmodule Touchpad.Scene.Sensor do
  use Scenic.Scene

  alias Scenic.Graph

  import Scenic.Primitives
  import Scenic.Components

  alias Touchpad.Component.Nav
  alias Touchpad.Component.Notes

  @body_offset 80
  @font_size 160
  @degrees "°"

  @pubsub_data {Scenic.PubSub, :data}
  @pubsub_registered {Scenic.PubSub, :registered}

  @notes """
    \"Sensor\" is a simple scene that displays data from a simulated sensor.
    The sensor is in /lib/sensors/temperature and uses Scenic.Sensor
    The buttons are placeholders showing custom alignment.
  """

  @moduledoc """
  This version of `Sensor` illustrates using spec functions to
  construct the display graph. Compare this with `SensorSpec` which uses
  spec descriptions.
  """

  # ============================================================================
  # setup

  # --------------------------------------------------------
  @doc false
  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    # Align the buttons and the temperature display. This has to be done at runtime
    # as we won't know the viewport dimensions until then.
    {width, _} = scene.viewport.size
    col = width / 6

    # build the graph
    graph =
      Graph.build(font: :roboto, font_size: 16)
      # text input
      |> group(
        fn graph ->
          graph
          |> text(
            "",
            id: :temperature,
            text_align: :center,
            font_size: @font_size,
            translate: {width / 2, @font_size}
          )
          |> group(
            fn g ->
              g
              |> button("Calibrate", width: col * 4, height: 46, theme: :primary)
              |> button(
                "Maintenance",
                width: col * 2 - 6,
                height: 46,
                theme: :secondary,
                translate: {0, 60}
              )
              |> button(
                "Settings",
                width: col * 2 - 6,
                height: 46,
                theme: :secondary,
                translate: {col * 2 + 6, 60}
              )
            end,
            translate: {col, @font_size + 60},
            button_font_size: 24
          )
        end,
        translate: {0, @body_offset}
      )

      # NavDrop and Notes are added last so that they draw on top
      |> Nav.add_to_graph(__MODULE__)
      |> Notes.add_to_graph(@notes)

    # subscribe to the simulated temperature sensor
    Scenic.PubSub.subscribe(:temperature)

    scene =
      scene
      |> assign(:graph, graph)
      |> push_graph(graph)

    {:ok, scene}
  end

  # --------------------------------------------------------
  # receive updates from the simulated temperature sensor
  @doc false
  @impl GenServer
  def handle_info({@pubsub_data, {:temperature, kelvin, _}}, %{assigns: %{graph: graph}} = scene) do
    # (9 / 5 * (kelvin - 273) + 32)     # Fahrenheit
    # Celsius
    temperature =
      (kelvin - 273)
      |> :erlang.float_to_binary(decimals: 1)

    # center the temperature on the viewport
    graph = Graph.modify(graph, :temperature, &text(&1, temperature <> @degrees))

    scene =
      scene
      |> assign(graph: graph)
      |> push_graph(graph)

    {:noreply, scene}
  end

  def handle_info({@pubsub_registered, _}, scene) do
    {:noreply, scene}
  end
end
