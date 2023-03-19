defmodule Restaurant.Restaurants.RestaurantQuery do
  use Ecto.Schema
  import Ecto.Changeset
  import Integer, only: [is_even: 1, is_odd: 1]

  schema "restaurant_queries" do
    field(:name, :string)
    field(:order_id, :integer)
    field(:restaurant_id, :integer)
    # confirmed, rejected
    field(:status, :string)

    timestamps()
  end

  @doc false
  def changeset(restaurant_query, attrs) do
    attrs = map_status(attrs)

    restaurant_query
    |> cast(attrs, [:name, :status, :restaurant_id, :order_id])
    |> validate_required([:name, :status, :restaurant_id, :order_id])
  end

  defp map_status(%{"restaurant_id" => restaurant_id} = attrs),
    do: map_status(attrs, "status", restaurant_id)

  defp map_status(%{restaurant_id: restaurant_id} = attrs),
    do: map_status(attrs, :status, restaurant_id)

  defp map_status(attrs), do: attrs

  defp map_status(attrs, name, restaurant_id) do
    case restaurant_id do
      nil -> attrs
      _ when is_even(restaurant_id) -> Map.put(attrs, name, "confirmed")
      _ when is_odd(restaurant_id) -> Map.put(attrs, name, "rejected")
    end
  end
end
