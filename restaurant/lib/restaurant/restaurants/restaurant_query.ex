defmodule Restaurant.Restaurants.RestaurantQuery do
  use Ecto.Schema
  import Ecto.Changeset
  alias Restaurant.Repo

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
    use Machinery,
      field: :status,
      states: ["requested", "available", "unavailable"],
      transitions: %{
        "requested" => ["available", "unavailable"]
      }

    def persist(struct, next_state) do
      {:ok, query} = change(struct, %{status: next_state}) |> Repo.update()
      query
    end
  end
end
