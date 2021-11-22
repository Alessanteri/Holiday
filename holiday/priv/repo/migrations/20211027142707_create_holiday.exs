defmodule Holiday.Repo.Migrations.CreateHoliday do
  use Ecto.Migration

  def change do
    create table(:holiday) do
      add(:name, :string, null: false)
      add(:dtstart, :date, null: false)
      add(:dtend, :date, null: false)
    end
  end
end
