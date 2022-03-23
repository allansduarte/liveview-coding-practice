defmodule PentoWeb.Pento.Title do
  use Phoenix.Component

  def render(assigns) do
    ~H"""
    <h1>{ @message }</h1>
    """
  end
end
