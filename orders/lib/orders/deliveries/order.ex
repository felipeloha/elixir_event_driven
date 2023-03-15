defmodule Orders.Deliveries.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    # requested, rejected, confirmed
    field(:name, :string)
    field(:status, :string, default: "requested")

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:name, :status])
    |> validate_required([:name])
  end

  defmodule OrderStateMachine do
    alias Orders.Deliveries

    use Machinery,
      field: :status,
      states: ["requested", "confirmed", "rejected"],
      transitions: %{
        "requested" => ["confirmed", "rejected"]
      }

    def persist(struct, next_state) do
      {:ok, order} = Deliveries.update_order(struct, %{status: next_state})
      order
    end
  end
end
