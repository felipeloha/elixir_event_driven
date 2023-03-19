defmodule Restaurant.Restaurants.RestaurantQuery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restaurant_queries" do
    field :name, :string
    field :order_id, :integer
    field :restaurant_id, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(restaurant_query, attrs) do
    restaurant_query
    |> cast(attrs, [:name, :status, :restaurant_id, :order_id])
    |> validate_required([:name, :status, :restaurant_id, :order_id])
  end
end
