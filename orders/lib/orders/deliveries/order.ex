defmodule Orders.Deliveries.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    # requested, rejected, confirmed
    field(:name, :string)
    field(:status, :string)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:name, :status])
    |> validate_required([:name])
    |> IO.inspect()
    |> validate_status()
  end

  defp validate_status(%{data: %{status: current}, changes: %{status: status}}),
    do: validate_status(current, status)

  defp validate_status(cs), do: cs

  defp validate_status("requested", "rejected"), do: true
  defp validate_status("requested", "confirmed"), do: true
  defp validate_status(_, _), do: false
end
