defmodule PentoWeb.Pento.Board do
  use Surface.LiveComponent

  import PentoWeb.Pento.Colors

  alias PentoWeb.Pento.{Canvas, Palette, Shape}
  alias Pento.Game.{Board}

  prop puzzle, :string

  def render(assigns) do
    ~F"""
    <div id={ @id }>
      <Canvas viewBox="0 0 200 70">
        <Shape
          points={ @shape.points }
          fill={ color(@shape.color) }
          name={ @shape.name } />
      </Canvas>
      <hr/>
    </div>
    """
  end

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_id(id)
     |> assign_puzzle(puzzle)
     |> assign_board()
     |> assign_shape()}
  end

  def assign_id(socket, id) do
    assign(socket, id: id)
  end

  def assign_puzzle(socket, puzzle) do
    assign(socket, puzzle: puzzle)
  end

  def assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    board =
      puzzle
      |> String.to_existing_atom()
      |> Board.new()

    assign(socket, board: board)
  end

  def assign_shape(%{assigns: %{board: board}} = socket) do
    assign(socket, shape: Board.to_shape(board))
  end
end
