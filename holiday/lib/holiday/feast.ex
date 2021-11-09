defmodule Holiday.Feast do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Holiday.{Repo, Feast}

  schema "holiday" do
    field(:name, :string)
    field(:dtstart, :date, null: false)
    field(:dtend, :date, null: false)
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :dtstart, :dtend])
    |> validate_required([:name, :dtstart, :dtend])
  end

  def set_struct_if_not_nil(struct) do
    if is_nil(struct.name) or is_nil(struct.dtstart) or is_nil(struct.dtend) do
      false
    else
      true
    end
  end

  def save_data(struct) do
    if changeset(struct, struct) do
      Holiday.Repo.insert(struct)
    end
  end

  def clear_database() do
    Ecto.Query.from(Feast)
    |> Repo.delete_all()
  end

  def get_data_for_today(day) do
    Ecto.Query.from(f in Feast, where: f.dtstart == ^day)
    |> Repo.all()
  end

  def get_data(day) do
    Ecto.Query.from(f in Feast, where: f.dtstart >= ^day)
    |> Repo.all()
  end
end
