defmodule Touchpad.MixProject do
  use Mix.Project

  @app :touchpad
  @version "0.1.0"
  @all_targets [:rpi, :rpi0, :rpi3, :rpi4, :bbb, :x86_64]

  def project do
    [
      app: @app,
      version: @version,
      elixir: "~> 1.9",
      archives: [nerves_bootstrap: "~> 1.10"],
      start_permanent: Mix.env() == :prod,
      build_embedded: true,
      deps: deps(),
      releases: [{@app, release()}],
      preferred_cli_target: [run: :host, test: :host]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Touchpad.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # Dependencies for all targets
      {:nerves, "~> 1.7.16", runtime: false},
      {:shoehorn, "~> 0.8.0"},
      {:ring_logger, "~> 0.8.5"},
      {:toolshed, "~> 0.2.13"},

      # Scenic
      {:scenic, "~> 0.11.0-beta.0"},
      {:scenic_driver_local, "~> 0.11.0-beta.0"},
      # Dependencies for all targets except :host
      {:nerves_runtime, "~> 0.12", targets: @all_targets},
      {:nerves_pack, "~> 0.7.0", targets: @all_targets},
      {:nerves_hub_cli, "~> 0.12", runtime: false},
      {:nerves_hub_link, "~> 1.2", targets: @all_targets},
      {:nerves_time, "~> 0.4.5", targets: @all_targets},
      # Network
      # Dependencies for specific targets
      # NOTE: It's generally low risk and recommended to follow minor version
      # bumps to Nerves systems. Since these include Linux kernel and Erlang
      # version updates, please review their release notes in case
      # changes to your application are needed.
      {:nerves_system_rpi, "~> 1.19", runtime: false, targets: :rpi},
      {:nerves_system_rpi0, "~> 1.19", runtime: false, targets: :rpi0},
      {:nerves_system_rpi3, "~> 1.19", runtime: false, targets: :rpi3},
      {:nerves_system_rpi4, "~> 1.19", runtime: false, targets: :rpi4},
      {:nerves_system_bbb, "~> 2.13", runtime: false, targets: :bbb},
      {:nerves_system_x86_64, "~> 1.19", runtime: false, targets: :x86_64}
    ]
  end

  def release do
    [
      overwrite: true,
      # Erlang distribution is not started automatically.
      # See https://hexdocs.pm/nerves_pack/readme.html#erlang-distribution
      cookie: "#{@app}_cookie",
      include_erts: &Nerves.Release.erts/0,
      steps: [&Nerves.Release.init/1, :assemble],
      strip_beams: Mix.env() == :prod or [keep: ["Docs"]]
    ]
  end
end
