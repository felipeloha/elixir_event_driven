defmodule Orders.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :name, :string, default: "requested"
      add :status, :string

      timestamps()
    end
  end
end
