defmodule LiveViewStudio.Stores do
  @moduledoc false

  import Ecto.Query, warn: false

  alias LiveViewStudio.Repo
  alias LiveViewStudio.Stores.Store

  def search_by_zip(zip) do
    from(s in Store, where: s.zip == ^zip)
    |> Repo.all()
  end

  def search_by_city(city) do
    from(s in Store, where: s.city == ^city)
    |> Repo.all()
  end

  @doc """
  Creates a store.
  ## Examples
      iex> create_store(%{field: value})
      {:ok, %Store{}}
      iex> create_store(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_store(attrs \\ %{}) do
    %Store{}
    |> Store.changeset(attrs)
    |> Repo.insert()
  end
end
