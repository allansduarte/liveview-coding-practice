defmodule LiveViewStudioWeb.FlightsLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  test "typing in airport field suggests a origin", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#airport-search", %{airport: "DEN"})
    |> render_change()

    assert has_element?(view, "#matches option", "DEN")
  end

  test "search by flight number shows matching flights", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#flights-search", %{number: "450"})
    |> render_submit()

    assert has_element?(view, "li", "450")
    assert has_element?(view, "li", "DEN")
    assert has_element?(view, "li", "ORD")
  end

  test "search by airport shows matching flights", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#airport-search", %{airport: "DEN"})
    |> render_submit()

    assert has_element?(view, "li", "450")
    assert has_element?(view, "li", "DEN")
    assert has_element?(view, "li", "ORD")
  end

  test "search by flight number with no results shows error", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#flights-search", %{number: "80204"})
    |> render_submit()

    assert render(view) =~ "No flights matching 80204"
  end

  test "search by airport with no results shows error", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/flights")

    view
    |> form("#airport-search", %{airport: "DDD"})
    |> render_submit()

    assert render(view) =~ "No flights matching DDD"
  end
end
