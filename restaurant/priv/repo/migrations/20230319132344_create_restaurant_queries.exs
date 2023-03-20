defmodule Restaurant.Repo.Migrations.CreateRestaurantQueries do
  use Ecto.Migration

  def change do
    create table(:restaurant_queries) do
      add :name, :string
      add :status, :string
      add :restaurant_id, :integer
      add :order_id, :integer

      timestamps()
    end
  end
end
