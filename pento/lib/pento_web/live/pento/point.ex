defmodule PentoWeb.Pento.Point do
  use Surface.Component

  @width 10

  @doc "The X axis"
  prop x, :integer

  @doc "The Y axis"
  prop y, :integer

  @doc "The fill"
  prop fill, :string

  @doc "The name"
  prop name, :string

  def render(assigns) do
    ~F"""
    <use
      xlink:href="#point"
      x={ convert @x }
      y={ convert @y }
      fill={ @fill } />
    """
  end

  defp convert(axis) do
    axis * @width + 2 * @width
  end
end
