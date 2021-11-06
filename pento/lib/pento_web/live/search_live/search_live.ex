defmodule PentoWeb.SearchLive do
  use PentoWeb, :live_view

  alias Pento.Catalog.Search

  @impl true
  def mount(_params, _session, socket) do
    socket = assign(socket, search: %Search{})
    {:ok, socket}
  end
end
