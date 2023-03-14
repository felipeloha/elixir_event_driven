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
    |> validate_status()
  end

  defp validate_status(%{data: %{status: current}, changes: %{status: status}} = changeset),
    do: validate_status(changeset, current, status)

  defp validate_status(changeset), do: changeset

  defp validate_status(changeset, "requested", "rejected"), do: changeset
  defp validate_status(changeset, "requested", "confirmed"), do: changeset

  defp validate_status(changeset, _, _),
    do: add_error(changeset, :status, "invalid_status_transition")
end
