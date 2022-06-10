defmodule Touchpad.Scene.Calendar do
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives

  @graph Graph.build()
         |> group(
           fn g ->
             g
             |> rounded_rectangle({400, 200, 8},
               stroke: {2, {:color, :orange}},
               fill: :white
             )
             |> text("Test Screen", font_size: 22, translate: {10, 28}, fill: :black)
           end,
           translate: {40, 40}
         )

  def init(_scene_args, _options) do
    {:ok, @graph, push: @graph}
  end
end