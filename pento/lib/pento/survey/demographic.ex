defmodule Pento.Survey.Demographic do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pento.Accounts.User

  @genders ["male", "female", "other", "prefer not to say"]
  @education_levels [
    "high school",
    "bachelor’s degree",
    "graduate degree",
    "other",
    "prefer not to say"
  ]
  @required [:gender, :year_of_birth, :user_id, :education_level]

  schema "demographics" do
    field(:gender, :string)
    field(:year_of_birth, :integer)
    field(:education_level, :string)
    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(demographic, attrs) do
    demographic
    |> cast(attrs, @required)
    |> validate_required(@required)
    |> validate_inclusion(:gender, @genders)
    |> validate_inclusion(:year_of_birth, 1900..Date.utc_today().year)
    |> validate_inclusion(:education_level, @education_levels)
    |> unique_constraint(:user_id)
  end

  def genders, do: @genders
  def education_levels, do: @education_levels
end
