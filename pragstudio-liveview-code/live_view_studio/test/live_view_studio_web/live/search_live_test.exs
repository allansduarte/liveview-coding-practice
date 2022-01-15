defmodule LiveViewStudioWeb.SearchLiveTest do
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

  test "search shows matching stores", %{conn: conn} do
    create_store(name: "Downtown Denver", zip: "80204")
    create_store(name: "Midtown Denver", zip: "80204")
    create_store(name: "Denver Stapleton", zip: "80204")
    create_store(name: "Denver West", zip: "80204")

    {:ok, view, _html} = live(conn, "/search")

    view
    |> form("#zip-search", %{zip: 80204})
    |> render_submit()

    assert has_element?(view, "li", "Downtown Denver")
    assert has_element?(view, "li", "Midtown Denver")
    assert has_element?(view, "li", "Denver Stapleton")
    assert has_element?(view, "li", "Denver West")
  end

  test "search with no results shows error", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/search")

    view
    |> form("#zip-search", %{zip: 00000})
    |> render_submit()

    assert render(view) =~ "No stores matching"
  end
end
