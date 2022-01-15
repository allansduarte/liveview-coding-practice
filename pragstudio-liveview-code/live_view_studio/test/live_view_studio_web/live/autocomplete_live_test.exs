defmodule LiveViewStudioWeb.AutocompleteLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudio.Stores

  def create_store(attrs) do
    {:ok, store} =
      attrs
      # these fields are irrelevant for tests:
      |> Enum.into(%{
        street: "street",
        phone_number: "phone",
        city: "city",
        open: true,
        hours: "hours"
      })
      |> Stores.create_store()

    store
  end

  test "typing in city field suggests a city", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    view
    |> form("#city-search", %{city: "D"})
    |> render_change()

    assert has_element?(view, "#matches option", "Denver, CO")
  end

  test "search by city shows matching stores", %{conn: conn} do
    create_store(name: "Downtown Denver", zip: "80204", city: "Denver, CO")
    create_store(name: "Midtown Denver", zip: "80204", city: "Denver, CO")
    create_store(name: "Denver Stapleton", zip: "80204", city: "Denver, CO")
    create_store(name: "Denver West", zip: "80204", city: "Denver, CO")

    {:ok, view, _html} = live(conn, "/autocomplete")

    view
    |> form("#city-search", %{city: "Denver, CO"})
    |> render_submit()

    assert has_element?(view, "li", "Downtown Denver")
    assert has_element?(view, "li", "Midtown Denver")
    assert has_element?(view, "li", "Denver Stapleton")
    assert has_element?(view, "li", "Denver West")
  end

  test "search by city with no results shows error", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/autocomplete")

    view
    |> form("#city-search", %{city: ""})
    |> render_submit()

    assert render(view) =~ "No stores matching"
  end
end
