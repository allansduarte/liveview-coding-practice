defmodule PentoWeb.Pento.Canvas do
  use Surface.Component

  prop viewBox, :string
  slot default, required: true

  def render(assigns) do
    ~F"""
    <svg viewBox={ @viewBox }>
      <defs>
        <rect id="point" width="10" height="10" />
      </defs>
      <slot/>
    </svg>
    """
  end
end
