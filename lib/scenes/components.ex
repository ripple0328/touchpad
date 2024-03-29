defmodule Touchpad.Scene.Components do
  @moduledoc """
  Sample scene.
  """

  use Scenic.Scene
  alias Scenic.Graph
  import Scenic.Primitives
  import Scenic.Components
  import Scenic.Clock.Components

  alias Touchpad.Component.Nav
  alias Touchpad.Component.Notes

  @body_offset 60

  @notes """
    \"Components\" shows the basic components available in Scenic.
    Messages sent by the component are displayed live.
    The crash button raises an error, demonstrating how recovery works.
  """

  @header [
    text_spec("Various components", translate: {15, 20}),
    text_spec("Event received:", translate: {15, 65}, id: :event_text),
    # this button will cause the scene to crash.
    button_spec("Crash", id: :btn_crash, theme: :danger, t: {370, 0})
  ]

  ##
  # Now the specs for the various components we'll display

  @buttons [
    button_spec("Primary", id: :btn_primary, theme: :primary),
    button_spec("Success", id: :btn_success, t: {111, 0}, theme: :success),
    button_spec("Info", id: :btn_info, t: {228, 0}, theme: :info),
    button_spec("Warning", id: :btn_warning, t: {305, 0}, theme: :warning),
    button_spec("Secondary",
      id: :btn_secondary,
      t: {0, 44},
      theme: :secondary
    ),
    button_spec("Danger", id: :btn_danger, theme: :danger, t: {136, 44}),
    button_spec("Text", id: :btn_text, t: {241, 44}, theme: :text)
  ]

  @slider slider_spec({{0, 100}, 0}, id: :num_slider, t: {0, 100})

  @radio_group radio_group_spec(
                 {[
                    {"Radio A", :radio_a},
                    {"Radio B", :radio_b},
                    {"Radio C", :radio_c}
                  ], :radio_b},
                 id: :radio_group,
                 t: {0, 126}
               )

  @checkbox checkbox_spec({"Check Box", true}, id: :check_box, t: {200, 126})

  @toggle toggle_spec(false, id: :toggle, t: {340, 120})

  @text_field text_field_spec("Some text",
                id: :text,
                width: 240,
                hint: "Type here...",
                t: {200, 160}
              )

  @password_field text_field_spec("",
                    id: :password,
                    width: 240,
                    hint: "Password",
                    type: :password,
                    t: {200, 200}
                  )

  @dropdown dropdown_spec(
              {
                [{"Choice A", :choice_a}, {"Choice B", :choice_b}, {"Choice C", :choice_c}],
                :choice_a
              },
              id: :dropdown,
              translate: {0, 202}
            )

  @dropdown2 dropdown_spec(
               {
                 [
                   {"Choice 1", :choice_1},
                   {"Choice 2", :choice_2},
                   {"Choice 3", :choice_3},
                   {"Choice 4", :choice_4}
                 ],
                 :choice_2
               },
               id: :dropdown,
               translate: {0, 250}
             )

  ##
  # Put them all together
  @components [
    # treat the buttons as a group so we can translate them all
    group_spec(@buttons, translate: {0, 10}),
    @slider,
    @radio_group,
    @checkbox,
    @toggle,
    @text_field,
    @password_field,
    @dropdown2,
    @dropdown
  ]

  ##
  # And build the final graph
  @graph Graph.build(font: :roboto, font_size: 24)
         |> Notes.add_to_graph(@notes)
         |> add_specs_to_graph(
           [
             @header,
             group_spec(@components, t: {15, 74})
           ],
           translate: {0, @body_offset + 20}
         )

         # Nav and Notes are added last so that they draw on top
         |> Nav.add_to_graph(__MODULE__)
         |> analog_clock(
           seconds: true,
           radius: 60,
           ticks: true,
           translate: {650, 150}
         )

  @event_str "Event received: "

  # ============================================================================

  defp graph(), do: @graph

  @doc false
  @impl Scenic.Scene
  def init(scene, _param, _opts) do
    scene = push_graph(scene, graph())
    {:ok, scene}
  end

  @doc false
  @impl Scenic.Scene
  # force the scene to crash
  def handle_event({:click, :btn_crash}, _, _scene) do
    raise "The crash button was pressed. Crashing now..."
    # No need to return anything. Already crashed.
  end

  # display the received message
  def handle_event(event, _, scene) do
    graph = Graph.modify(graph(), :event_text, &text(&1, @event_str <> inspect(event)))

    scene = push_graph(scene, graph)

    {:noreply, scene}
  end
end
