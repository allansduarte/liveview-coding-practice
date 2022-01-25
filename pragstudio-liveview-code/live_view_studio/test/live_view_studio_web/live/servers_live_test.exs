defmodule LiveViewStudioWeb.ServersLiveTest do
  use LiveViewStudioWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias LiveViewStudio.Servers

  test "clicking a server link shows its details", ctx do
    first = create_server("First")
    second = create_server("Second")

    {:ok, view, _html} = live(ctx.conn, "/servers")

    assert has_element?(view, "nav", first.name)
    assert has_element?(view, "nav", second.name)
    assert has_element?(view, "#selected-server", second.name)

    view
    |> element("nav a", first.name)
    |> render_click()

    assert has_element?(view, "#selected-server", first.name)
    assert_patched(view, "/servers?id=#{first.id}")
  end

  test "selects the server identified in the URL", ctx do
    first = create_server("First")
    _second = create_server("Second")

    {:ok, view, _html} = live(ctx.conn, "/servers?id=#{first.id}")

    assert has_element?(view, "#selected-server", first.name)
  end

  test "adds valid server to list", ctx do
    {:ok, view, _html} = live(ctx.conn, "/servers/new")

    valid_attrs = %{
      name: "valid-server",
      framework: "elixir",
      size: 128,
      git_repo: "https//www.gitrepo.com"
    }

    view
    |> form("#create-server", %{server: valid_attrs})
    |> render_submit()

    assert has_element?(view, "#servers", valid_attrs.name)
  end

  test "display live validations", ctx do
    {:ok, view, _html} = live(ctx.conn, "/servers/new")

    invalid_attrs = %{name: "invalid-server"}

    view
    |> form("#create-server", %{server: invalid_attrs})
    |> render_submit()

    assert has_element?(view, "#create-server", "can't be blank")
  end

  test "clicking status button toggles status", ctx do
    server = create_server("valid-server")

    {:ok, view, _html} = live(ctx.conn, "/servers")

    status_button = "#server-#{server.id} button"

    view
    |> element(status_button, "up")
    |> render_click()

    assert has_element?(view, status_button, "down")
  end

  test "clicking cancel button back to the list servers", ctx do
    {:ok, view, _html} = live(ctx.conn, "/servers/new")

    view
    |> element("#cancel-server", "Cancel")
    |> render_click()

    assert_patch(view, "/servers")
  end

  test "receives real-time updates", ctx do
    {:ok, view, _html} = live(ctx.conn, "/servers")

    external_server = create_server("external-valid-server")

    assert has_element?(view, "#servers", external_server.name)
  end

  defp create_server(name) do
    {:ok, server} =
      Servers.create_server(%{
        name: name,
        # these are irrelevant for tests:
        status: "up",
        deploy_count: 1,
        size: 1.0,
        framework: "framework",
        git_repo: "repo",
        last_commit_id: "id",
        last_commit_message: "message"
      })

    server
  end
end
