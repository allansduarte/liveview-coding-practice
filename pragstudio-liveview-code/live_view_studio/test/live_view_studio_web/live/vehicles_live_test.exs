defmodule LiveViewStudioWeb.VehiclesLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  defp create_vehicle(make) do
    {:ok, vehicle} =
      LiveViewStudio.Vehicles.create_vehicle(%{
        # these are irrelevant for tests:
        color: "Orange",
        make: make,
        model: "X1"
      })

    vehicle
  end

  defp vehicle_row(vehicle), do: "#vehicle-#{vehicle.id}"

  test "clicking next, previous, and page links patch the URL", %{conn: conn} do
    _a = create_vehicle("Vehicle A")
    _b = create_vehicle("Vehicle B")
    _c = create_vehicle("Vehicle C")

    {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=1")

    view
    |> element("a", "Next")
    |> render_click()

    assert_patched(view, "/vehicles?page=2&per_page=1")

    view
    |> element("a", "Previous")
    |> render_click()

    assert_patched(view, "/vehicles?page=1&per_page=1")

    view
    |> element("a", "2")
    |> render_click()

    assert_patched(view, "/vehicles?page=2&per_page=1")
  end

  # test "paginates using the options in the URL", %{conn: conn} do
  #   a = create_vehicle("Vehicle A")
  #   b = create_vehicle("Vehicle B")

  #   {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=1")

  #   assert has_element?(view, vehicle_row(a))
  #   refute has_element?(view, vehicle_row(b))

  #   {:ok, view, _html} = live(conn, "/vehicles?page=2&per_page=1")

  #   refute has_element?(view, vehicle_row(a))
  #   assert has_element?(view, vehicle_row(b))

  #   {:ok, view, _html} = live(conn, "/vehicles?page=1&per_page=2")

  #   assert has_element?(view, vehicle_row(a))
  #   assert has_element?(view, vehicle_row(b))
  # end

  test "changing the per-page form patches the URL", %{conn: conn} do
    {:ok, view, _html} = live(conn, "/vehicles?page=2")

    view
    |> form("#select-per-page", %{"per-page": 10})
    |> render_change()

    assert_patched(view, "/vehicles?page=2&per_page=10")
  end
end
