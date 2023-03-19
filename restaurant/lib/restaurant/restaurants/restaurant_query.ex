defmodule Restaurant.Restaurants.RestaurantQuery do
  use Ecto.Schema
  import Ecto.Changeset

  schema "restaurant_queries" do
    field(:name, :string)
    field(:order_id, :integer)
    field(:restaurant_id, :integer)
    # requested, confirmed, rejected
    field(:status, :string, default: "requested")

    timestamps()
  end

  @doc false
  def changeset(restaurant_query, attrs) do
    restaurant_query
    |> cast(attrs, [:name, :restaurant_id, :order_id])
    |> validate_required([:name, :status, :restaurant_id, :order_id])
  end

  defmodule QueryStateMachine do
    alias Restaurant.Restaurants

    use Machinery,
      field: :status,
      states: ["requested", "confirmed", "rejected"],
      transitions: %{
        "requested" => ["confirmed", "rejected"]
      }

    def persist(struct, next_state) do
      {:ok, query} = Restaurants.update_restaurant_query(struct, %{status: next_state})
      query
    end
  end
end
