require_relative 'product'
require_relative 'menu'
class AdminOperations
  def initialize
    @productoken = Product.new
  end
  
  def put_and_get(msg)
    max_attempts = 3
    attempts = 0
    loop do
      puts msg
      input = gets.chomp.strip
      return input unless input.empty?
      attempts += 1
      if attempts >= max_attempts
        puts "You have entered an empty input #{max_attempts} times. Please try again"
        exit
      end
    end
  end
  
  # this method is called from admin menu
  # this method call's 2 methods manually
  # (add_product()) and (delete_product)
  
  def manage_products
    loop_runner = true
    while loop_runner
      puts
      @productoken.browse_products
      puts('Manage Products:')
      puts('==================================================================')
      puts('1.Add Product')
      puts('2.Delete Product')
      puts('3.Update Product')
      puts('4. Exit')
      puts
      print('Please enter your choice: ')
      ad_choice = gets.chomp.to_i
      unless (1..4).include?(ad_choice)
        puts('Invalid input. Please enter a valid choice (1, 2, 3 and 4).')
        next
      end
      puts
      case ad_choice
      when 1
        name = put_and_get('Enter Name of your Product')
        price = put_and_get('Enter Price of your Product')
        category = put_and_get('Enter Category of the product')
        add_product(name, price, category)
      when 2
        delete_product
      when 3
        update_product
      when 4
        loop_runner = false
      end
    end
  end
  
  # referring all the methods to menu so we dont
  # have to create object 2nd time of product
  
  def browse_products
    @productoken.browse_products
  end
  
  def search_product
    @productoken.search_product
  end
  
  def add_cart
    @productoken.add_cart
  end
  
  def view_cart
    @productoken.view_cart
  end
  
  def checkout(current_user)
    @productoken.checkout(current_user)
  end
  
  def order_history
    @productoken.order_history
  end

  # I have made this method for exporting the data of Orders corresponding to users
  # during the time of checkout i have pushed the data into shipping_details and i've
  # accessed here the same data and then i exported into (order_history.csv) file.
  # It is called from ((Menu.rb)export data menu

  def export_orders
    if @productoken.shipping_details.empty?
      puts "\nNo Orders found yet Found"
    else
      ordered_data = "Username,Product,Price,Total,Quantity,Address\n"
      @productoken.shipping_details.each do |order|
        ordered_data  << "#{order.order_by},#{order.product_name},$#{order.price},$#{order.total},#{order.quantity},#{order.address}\n"
      end
      File.write('order_history.csv', ordered_data)
      puts "\tOrder History data has been Exported"
    end
  end
  

  # I have made this method for exporting the data of products.When admin add the product
  # the particular product was pushed in products array then we accessed here 
  # with the help of object and then i exported into (product.csv) file.
  # It is called from ((Menu.rb)export data menu.

  def export_products
    if @productoken.products.empty?
      puts "\nNo products Found"
    else
      product_data = "Name,Price,Category\n"
      @productoken.products.each do |product|
        product_data << "#{product[:name]},$#{product[:price]},#{product[:category]}\n"
      end
      File.write('product.csv', product_data)
      puts "\tProduct data has been Exported"
    end
  end


  def update_product
    if @productoken.products.empty?
      puts 'No Product Available'
    else
      @productoken.browse_products
      input_from_admin = put_and_get('Enter the index of the product to update').to_i - 1
      
      if input_from_admin.between?(0, @productoken.products.length - 1)
        product_to_update = @productoken.products[input_from_admin]
        
        puts "Enter the updated details for product#{product_to_update[:name]}:"
        product_to_update[:index] = put_and_get('Enter updated index')
        product_to_update[:name] = put_and_get('Enter updated name')
        product_to_update[:price] = put_and_get('Enter updated price')
        product_to_update[:category] = put_and_get('Enter updated category')
        
        puts 'Product details updated successfully!'
      else
        puts 'Wrong input'
      end
    end
  end
  
  # this method is for adding the product from the admin side
  # it is called from (manage_product) method
  
  def add_product(name, price, category)
    product = { name: name, price: price, category: category }
    @productoken.products << product
    puts "Product added Successfully\n"
  end
  
  # this method is for removing the product from the admin side
  # it is called from (manage_product) method
  
  def delete_product
    @productoken.browse_products
    if @productoken.products.empty?
      puts 'No products are available'
    else
      input = put_and_get('Input Index of the item').to_i - 1
      @productoken.products.delete_at(input)
      puts "Product deleted Successfully\n"
    end
  end
end
