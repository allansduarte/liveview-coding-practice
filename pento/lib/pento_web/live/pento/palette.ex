defmodule PentoWeb.Pento.Palette do
  use Surface.Component

  import PentoWeb.Pento.Colors

  alias PentoWeb.Pento.{Shape, Canvas}
  alias Pento.Game.Pentomino

  prop shape_names, :list

  def mount(_params, _session, socket) do
    {:ok, socket, temporary_assigns: [shapes: []]}
  end

  def render(assigns) do
    ~F"""
    <Canvas viewBox="0 0 500 125">
      <Shape :for={ shape <- @shapes}
        points={ shape.points }
        fill={ color(shape.color) }
        name={ shape.name } />
    </Canvas>
    """
  end

  def update(%{shape_names: shape_names}, socket) do
    shapes =
      shape_names
      |> Enum.with_index()
      |> Enum.map(&pentomino/1)

    {:ok, assign(socket, shapes: shapes)}
  end

  defp pentomino({name, i}) do
    {x, y} = {rem(i, 6) * 4 + 3, div(i, 6) * 5 + 3}

    Pentomino.new(name: name, location: {x, y})
    |> Pentomino.to_shape()
  end
end
