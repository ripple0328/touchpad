import Config

# Add configuration that is only needed when running on the host here.
import Config

config :touchpad, :viewport, %{
  name: :main_viewport,
  default_scene: {Touchpad.Scene.Calendar, nil},
  size: {800, 480},
  opts: [scale: 1.0],
  drivers: [
    %{
      module: Scenic.Driver.Glfw,
      opts: [title: "MIX_TARGET=host, app = :touchpad"]
    }
  ]
}
