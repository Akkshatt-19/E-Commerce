class OrderDetails
  attr_accessor :order_by, :product_name, :price, :total,:quantity, :address
  def initialize(order_by, product_name, price, total, quantity, address)
    @order_by = order_by
    @product_name = product_name
    @price = price
    @total = total
    @quantity = quantity
    @address = address
  end
end
