defmodule LiveViewStudioWeb.DatePickerLive do
  use LiveViewStudioWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, date: nil)}
  end

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <form>
      <input id="date-picker-input" type="text"
        class="form-input" value="<%= @date %>"
        placeholder="Pick a date"
        phx-hook="DatePicker">

        <input id="phone" type="text"
          class="form-input"
          placeholder="Pick a phone"
          phx-hook="PhoneNumber">
      </form>

      <%= if @date do %>
        <p class="mt-6 text-xl">
          See you on <%= @date %>!
        </p>
      <% end %>
    </div>
    """
  end

  @impl true
  def handle_event("dates-picked", date, socket) do
    {:noreply, assign(socket, date: date)}
  end
end
