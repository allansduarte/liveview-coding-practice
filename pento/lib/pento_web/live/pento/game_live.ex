defmodule PentoWeb.Pento.GameLive do
  use Surface.LiveView

  alias PentoWeb.Pento.{Board, Title}

  def mount(%{"puzzle" => puzzle}, _session, socket) do
    {:ok, assign(socket, puzzle: puzzle)}
  end

  def render(assigns) do
    ~F"""
    <section class="container">
      <Title message="Welcome to Pento!" />
      <Board puzzle={ @puzzle } id="game" />
    </section>
    """
  end
end
