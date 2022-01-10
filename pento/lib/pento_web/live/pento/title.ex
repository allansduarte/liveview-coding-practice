defmodule PentoWeb.Pento.Title do
  use Surface.Component

  @doc "The message"
  prop message, :string, required: true

  def render(assigns) do
    ~F"""
    <h1>{ @message }</h1>
    """
  end
end
