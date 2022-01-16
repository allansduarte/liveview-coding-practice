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
