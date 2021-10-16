defmodule LiveViewStudio.GitRepos.GitRepo do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias LiveViewStudio.Repo

  schema "git_repos" do
    field(:fork, :boolean, default: false)
    field(:language, :string)
    field(:license, :string)
    field(:name, :string)
    field(:owner_login, :string)
    field(:owner_url, :string)
    field(:stars, :integer)
    field(:url, :string)

    timestamps()
  end

  @doc false
  def changeset(git_repo, attrs) do
    git_repo
    |> cast(attrs, [:name, :url, :owner_login, :owner_url, :language, :license, :fork, :stars])
    |> validate_required([
      :name,
      :url,
      :owner_login,
      :owner_url,
      :language,
      :license,
      :fork,
      :stars
    ])
  end

  @doc false
  def list_git_repos(criteria) when is_list(criteria) do
    query = from(g in GitRepo)

    Enum.reduce(criteria, query, fn
      {:language, ""}, query ->
        query

      {:language, language}, query ->
        from(q in query, where: q.language == ^language)

      {:license, ""}, query ->
        query

      {:license, license}, query ->
        from(q in query, where: q.license == ^license)
    end)
    |> Repo.all()
  end
end
