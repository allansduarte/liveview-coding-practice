defmodule LiveViewStudioWeb.SandboxCalculatorComponent do
  use LiveViewStudioWeb, :live_component

  alias LiveViewStudioWeb.QuoteComponent
  alias LiveViewStudio.SandboxCalculator

  @impl true
  def mount(socket) do
    socket = assign(socket, length: nil, width: nil, depth: nil, weight: 0)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <form phx-change="calculate" phx-target={@myself}"
          phx-submit="get-quote">
      <div class="field">
        <label for="length">Length:</label>
        <input type="number" name="length" value={@length} />
        <span class="unit">feet</span>
      </div>
      <div class="field">
        <label for="length">Width:</label>
        <input type="number" name="width" value={@width} />
        <span class="unit">feet</span>
      </div>
      <div class="field">
        <label for="length">Depth:</label>
        <input type="number" name="depth" value={@depth} />
        <span class="unit">inches</span>
      </div>
      <div class="weight">
        You need <%= @weight %> pounds
      </div>
      <button type="submit">
        Get Quote
      </button>
    </form>
    """
  end

  @impl true
  def handle_event("calculate", params, socket) do
    %{"length" => l, "width" => w, "depth" => d} = params

    weight = SandboxCalculator.calculate_weight(l, w, d)

    socket = assign(socket, length: l, width: w, depth: d, weight: weight)

    {:noreply, socket}
  end

  @impl true
  def handle_event("get-quote", _, socket) do
    weight = socket.assigns.weight
    price = SandboxCalculator.calculate_price(weight)

    send(self(), {__MODULE__, :totals, weight, price})
    {:noreply, socket}
  end
end
