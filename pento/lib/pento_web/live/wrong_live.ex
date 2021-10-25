defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  alias Pento.Accounts

  @start_score 0
  @start_message "Guess a number."
  @game_over_score -3

  @impl true
  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(
        user: Accounts.get_user_by_session_token(session["user_token"]),
        session_id: session["live_socket_id"]
      )
      |> assign_random_number()
      |> assign_reset_game()

    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
      It's <%= @current_time %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
      <% end %>
    </h2>

    <%= if (@game_over == true) do %>
    <div>
      <%= live_patch "Game Over",
      to: Routes.live_path(
        @socket,
        __MODULE__,
        game_over: true
      ),
      replace: true
      %>
    </div>
    <% end %>

    <pre>
    <%= @user.email %>
    <%= @session_id %>
    </pre>
    """
  end

  @impl true
  def handle_event("guess", %{"number" => guess}, %{assigns: assigns} = socket) do
    random_number = assigns.random_number
    guess = String.to_integer(guess)

    case guess do
      ^random_number ->
        socket =
          socket
          |> assign_random_number()
          |> assign_score("Your guess: #{guess}. Correct.", assigns.score + 1)

        {:noreply, socket}

      _ ->
        socket =
          socket
          |> assign_random_number()
          |> assign_score("Your guess: #{guess}. Wrong. Guess again.", assigns.score - 1)

        {:noreply, socket}
    end
  end

  @impl true
  def handle_params(%{"game_over" => "true"}, _uri, socket) do
    socket = assign_reset_game(socket)

    {:noreply, socket}
  end

  def handle_params(_, _uri, socket) do
    {:noreply, socket}
  end

  defp assign_reset_game(socket) do
    assign(socket,
      message: @start_message,
      score: @start_score,
      game_over: false,
      current_time: DateTime.utc_now() |> to_string
    )
  end

  defp assign_score(%{assigns: assigns} = socket, message, score) do
    cond do
      assigns[:game_over] && assigns.game_over == true ->
        socket

      true ->
        assign(
          socket,
          message: message,
          score: score,
          current_time: DateTime.utc_now() |> to_string
        )
        |> maybe_assign_game_over()
    end
  end

  defp assign_random_number(socket) do
    random_number = Enum.random(0..10)
    assign(socket, random_number: random_number)
  end

  defp maybe_assign_game_over(%{assigns: assigns} = socket) do
    game_over = if assigns.score <= @game_over_score, do: true, else: false

    assign(socket, game_over: game_over)
  end
end
