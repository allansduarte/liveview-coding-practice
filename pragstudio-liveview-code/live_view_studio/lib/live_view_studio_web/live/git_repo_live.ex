defmodule LiveViewStudioWeb.GitRepoLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.GitRepos

  def mount(_params, _session, socket) do
    socket = assign_defaults(socket)
    {:ok, socket}
  end

  def handle_event("filter", %{"language" => language, "license" => license}, socket) do
    params = [language: language, license: license]

    repos = GitRepos.list_git_repos(params)

    socket = assign(socket, params ++ [repos: repos])

    {:noreply, socket}
  end

  def handle_event("clear", _params, socket) do
    socket = assign_defaults(socket)
    {:noreply, socket}
  end

  defp assign_defaults(socket) do
    assign(socket, repos: GitRepos.list_git_repos(), language: "", license: "")
  end

  defp language_options do
    [
      "All Languages": "",
      "Elixir": "elixir",
      Ruby: "ruby",
      JavaScript: "js"
    ]
  end

  defp license_options do
    [
      "All Licenses": "",
      MIT: "mit",
      Apache: "apache",
      BSDL: "bsdl"
    ]
  end
end
