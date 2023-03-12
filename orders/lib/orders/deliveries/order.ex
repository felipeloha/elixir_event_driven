defmodule Orders.Deliveries.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:name, :status])
    |> validate_required([:name, :status])
  end
end
