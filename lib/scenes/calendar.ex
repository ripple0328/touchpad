defmodule Touchpad.Scene.Calendar do
  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives

  @impl Scenic.Scene
 def init(scene, _params, _opts) do
    graph = Graph.build()
    |> text("Hello World", font_size: 22, translate: {20, 80})
    scene =
      scene
      |> push_graph(graph)
    {:ok, scene}
  end
end
