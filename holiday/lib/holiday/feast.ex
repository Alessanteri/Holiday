defmodule Holiday.Feast do
  use Ecto.Schema
  import Ecto.Query

  schema "holiday" do
    field(:name, :string)
    field(:dtstart, :date, null: false)
    field(:dtend, :date, null: false)
  end

  def set_struct_if_not_nil(struct) do
    if is_nil(struct.name) or is_nil(struct.dtstart) or is_nil(struct.dtend) do
      false
    else
      true
    end
  end

  def sign_up(struct) do
    if set_struct_if_not_nil(struct) do
      Holiday.Repo.insert(struct)
    end
  end

  def get_data_for_today(day) do
    alias Holiday.{Repo, Feast}

    Ecto.Query.from(f in Feast, where: f.dtstart == ^day)
    |> Repo.all()
  end

  def get_data() do
    alias Holiday.{Repo, Feast}

    Ecto.Query.from(Feast)
    |> Repo.all()
  end
end
