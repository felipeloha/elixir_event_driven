defmodule Orders.DeliveriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Orders.Deliveries` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        name: "some name",
        status: "some status"
      })
      |> Orders.Deliveries.create_order()

    order
  end
end
