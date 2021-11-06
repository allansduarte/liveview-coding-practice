defmodule PentoWeb.SearchLive.FormComponent do
  use PentoWeb, :live_component

  alias Pento.Catalog

  @impl true
  def update(%{search: search} = assigns, socket) do
    changeset = Catalog.change_search(search)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(changeset: changeset)}
  end

  def handle_event("search", %{"search" => _search_params}, socket) do
    :timer.sleep(1000)
    {:noreply, socket}
  end

  @impl true
  def handle_event(
        "validate",
        %{"search" => search_params},
        %{assigns: %{search: search}} = socket
      ) do
    changeset =
      search
      |> Catalog.change_search(search_params)
      |> Map.put(:action, :validate)

    {:noreply,
     socket
     |> assign(:changeset, changeset)}
  end
end
