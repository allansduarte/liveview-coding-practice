defmodule LiveViewStudioWeb.SandboxLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudioWeb.{DeliveryChargeComponent, QuoteComponent, SandboxCalculatorComponent}

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, weight: nil, price: nil, delivery_charge: 0)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h1>Build A Sandbox</h1>

    <div id="sandbox">
      <%= live_component @socket, SandboxCalculatorComponent, id: 1, coupon: 10.0 %>

      <%= if @weight do %>
        <%= live_component @socket, DeliveryChargeComponent,
                          id: 1 %>

        <QuoteComponent.quote
          material="sand"
          weight={@weight}
          price={@price}
          hrs_until_expires="4",
          delivery_charge={@delivery_charge} />
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_info({SandboxCalculatorComponent, :totals, weight, price}, socket) do
    socket = assign(socket, weight: weight, price: price)
    {:noreply, socket}
  end

  @impl true
  def handle_info({:delivery_charge, charge}, socket) do
    socket = assign(socket, delivery_charge: charge)
    {:noreply, socket}
  end
end
