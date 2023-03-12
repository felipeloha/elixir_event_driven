defmodule Orders.DeliveriesTest do
  use Orders.DataCase

  alias Orders.Deliveries

  describe "orders" do
    alias Orders.Deliveries.Order

    import Orders.DeliveriesFixtures

    @invalid_attrs %{name: nil, status: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Deliveries.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Deliveries.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{name: "some name", status: "requested"}

      assert {:ok, %Order{} = order} = Deliveries.create_order(valid_attrs)
      assert order.name == "some name"
      assert order.status == "requested"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Deliveries.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{name: "some updated name", status: "rejected"}

      assert %Order{} = order = Deliveries.update_order!(order, update_attrs)
      assert order.name == "some updated name"
      assert order.status == "rejected"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()

      assert_raise(Ecto.InvalidChangesetError, fn ->
        Deliveries.update_order!(order, @invalid_attrs)
      end)

      assert order == Deliveries.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Deliveries.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Deliveries.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Deliveries.change_order(order)
    end
  end
end
