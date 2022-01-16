defmodule LiveViewStudioWeb.VolunteersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudio.Volunteers

  test "adds valid volunteer to list", ctx do
    {:ok, view, _html} = live(ctx.conn, "/volunteers")

    valid_attrs = %{name: "New Volunteer", phone: "303-555-1212"}

    view
    |> form("#create-volunteer", %{volunteer: valid_attrs})
    |> render_submit()

    assert has_element?(view, "#volunteers", valid_attrs.name)
  end

  test "display live validations", ctx do
    {:ok, view, _html} = live(ctx.conn, "/volunteers")

    invalid_attrs = %{name: "New Volunteer", phone: ""}

    view
    |> form("#create-volunteer", %{volunteer: invalid_attrs})
    |> render_submit()

    assert has_element?(view, "#create-volunteer", "can't be blank")
  end

  test "clicking status button toggles status", ctx do
    volunteer = create_volunteer()

    {:ok, view, _html} = live(ctx.conn, "/volunteers")

    status_button = "#volunteer-#{volunteer.id} button"

    view
    |> element(status_button, "Check Out")
    |> render_click()

    assert has_element?(view, status_button, "Check In")
  end

  test "receives real-time updates", ctx do
    {:ok, view, _html} = live(ctx.conn, "/volunteers")

    external_volunteer = create_volunteer()

    assert has_element?(view, "#volunteers", external_volunteer.name)
  end

  defp create_volunteer() do
    {:ok, volunteer} =
      Volunteers.create_volunteer(%{
        name: "New Volunteer",
        phone: "303-555-1212"
      })

    volunteer
  end
end
