# This file is responsible for configuring your application and its
# dependencies.
#
# This configuration file is loaded before any dependency and is restricted to
# this project.
import Config

# Enable the Nerves integration with Mix
Application.start(:nerves_bootstrap)

config :touchpad, target: Mix.target()

# Customize non-Elixir parts of the firmware. See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.

config :nerves, :firmware,
  provisioning: :nerves_hub_link,
  rootfs_overlay: "rootfs_overlay"


# Set the SOURCE_DATE_EPOCH date for reproducible builds.
# See https://reproducible-builds.org/docs/source-date-epoch/ for more information

config :nerves, source_date_epoch: "1654843902"

# Use Ringlogger as the logger backend and remove :console.
# See https://hexdocs.pm/ring_logger/readme.html for more information on
# configuring ring_logger.

config :logger, backends: [RingLogger]
config :scenic, :assets, module: Touchpad.Assets
config :touchpad, :viewport, [
  name: :main_viewport,
  theme: :dark,
  default_scene: Touchpad.Scene.Components,
  size: {800, 480},
  drivers: [
    [
      module: Scenic.Driver.Local,
      name: :local,
      window: [resizeable: false, title: "touchpad"],
      on_close: :stop_system
    ]
  ]
]

config :nerves_hub_user_api,
  host: "api.cremini.peridio.com"
config :nerves_hub_cli,
  org: System.get_env("NERVES_HUB_ORG")
# config :nerves_hub_link,
#   device_api_host: "device.cremini.peridio.com",
#   fwup_public_keys: [:devkey]

if Mix.target() == :host or Mix.target() == :"" do
  import_config "host.exs"
else
  import_config "target.exs"
end
