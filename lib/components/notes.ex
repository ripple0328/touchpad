defmodule Touchpad.Component.Notes do
  use Scenic.Component

  import Scenic.Primitives, only: [{:text, 3}, {:rect, 3}]

  @height 110
  @font_size 20
  @indent 30

  # --------------------------------------------------------
  @doc false
  @impl Scenic.Component
  def validate(notes) when is_bitstring(notes), do: {:ok, notes}

  def validate(data) do
    {
      :error,
      """
      #{IO.ANSI.red()}Invalid Touchpad.Component.Notes specification
      Received: #{inspect(data)}
      #{IO.ANSI.yellow()}
      Notes data should be a string
      """
    }
  end

  # --------------------------------------------------------
  @doc false
  @impl Scenic.Scene
  def init(scene, notes, opts) do
    {vp_width, vp_height} = scene.viewport.size

    {background, text} =
      case opts[:theme] do
        :dark ->
          {{48, 48, 48}, :white}

        :light ->
          {{220, 220, 220}, :black}

        _ ->
          {{48, 48, 48}, :white}
      end

    graph =
      Scenic.Graph.build(
        font_size: @font_size,
        font: :roboto,
        t: {0, vp_height - @height},
        theme: opts[:theme]
      )
      |> rect({vp_width, @height}, fill: background)
      |> text(notes, translate: {@indent, @font_size * 2}, fill: text)

    scene = push_graph(scene, graph)

    {:ok, scene}
  end
end
