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
end
