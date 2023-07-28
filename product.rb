require_relative 'order_details'
class Product
  attr_accessor :products, :order_list, :shipping_details
  
  def initialize
    @products = [
      { name: 'T-Shirt', price: 10, category: 'Clothing' },
      { name: 'Jeans', price: 20, category: 'Clothing' },
      { name: 'Sneakers', price: 30, category: 'Footwear' },
      { name: 'TV', price: 40, category: 'Appliances' },
      { name: 'Fridge', price: 50, category: 'Appliances' },
      { name: 'Shirt', price: 10, category: 'Clothing' },
      { name: 'Trouser', price: 20, category: 'Clothing' },
      { name: 'Floppers', price: 30, category: 'Footwear' },
      { name: 'Laptop', price: 40, category: 'Appliances' },
      { name: 'Washing Machine', price: 50, category: 'Appliances' }
    ]
    @shipping_details = []
    @user_cart = []
    @total = 0
  end
  
  # this method is called 2 times from menu.rb(user_menu)
  # one from browse_product and one from add_to_cart
  # it is used to show all the products of (@products) array
  # it is called by user
  
  def browse_products
    if @products.empty?
      puts 'No products Available'
    else
      puts 'Available products:'
      @products.each_with_index do |product, index|
        puts "#{index + 1}. #{product[:name]} - $#{product[:price]} - #{product[:category]}"
      end
    end
  end
  
  # this method is called from menu.rb(user_menu)
  # it takes input and it search it into all the keys of (@products)
  # array of hash & if it matches then it'll store it in (matched_products)
  # it'll call (matched_product) with the parameter as input.
  
  def search_product
    if @products.empty?
      puts('There are no items you are searching')
    else
      item_for_search = put_and_get('Enter the name of the product to search: ')
      matched_products = @products.select do |product|
        name_match = product[:name].downcase.include?(item_for_search.downcase)
        price_match = product[:price] == item_for_search.to_i
        category_match = product[:category].downcase == item_for_search.downcase
        name_match || price_match || category_match
      end
      matched_product(item_for_search, matched_products)
    end
  end
  
  # this is the method called from search product and
  # it shows all the matching product which are matched and stored in
  # (matched_products) array
  
  def matched_product(item_for_search, matched_products)
    if matched_products.empty?
      puts("No products are available matching '#{item_for_search}'.")
    else
      puts("Products matching with the name '#{item_for_search}' are:")
      matched_products.each do |product|
        puts "#{product[:name]} - $#{product[:price]}"
      end
    end
  end
  
  # this method is for if user hit enter key without giving any input
  # and i also added validation for exceeding empty input limit to 3
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
  
  # this method is called from menu.rb(user_menu) with a parameter
  # we have taken (product_to_purchase) as a input during selecting
  # add to cart from menu so this method recieve's that input
  # here we've stored selected items in (@user_cart)
  
  def add_cart
    index_to_add = put_and_get('Enter Index of product you want to add').to_i - 1
    quantity_to_purchase = put_and_get('Enter Quantity of product you want to add')
    product_found = false
    quantity = quantity_to_purchase.to_i
    product_total = 0
    if index_to_add.between?(0, products.length - 1)
      @user_cart << { name: @products[index_to_add][:name], price: @products[index_to_add][:price],category: @products[index_to_add][:category], quantity: quantity_to_purchase.to_i }
      product_total += @products[index_to_add][:price].to_i
      puts "#{quantity} #{@products[index_to_add][:name]}(s) have been added to the cart. Total for #{@products[index_to_add][:name]}(s): $#{product_total * quantity}"
    else
      puts 'Enter Valid Index'
    end
  end
  
  # this method is called from the 1'st case of (checkout)method
  # with a parameter and later removed from that (@user_cart)
  
  def remove_from_cart(product_to_remove, quantity_to_remove)
    # puts "#{@user_cart}"
    index_to_remove = product_to_remove.to_i - 1
    if index_to_remove.between?(0, @user_cart.length)
      if quantity_to_remove == @user_cart[index_to_remove][:quantity]
        @user_cart.delete_at(product_to_remove)
      elsif quantity_to_remove.to_i >= 1 && quantity_to_remove.to_i < @user_cart[index_to_remove][:quantity].to_i
        @user_cart[index_to_remove][:quantity] = @user_cart[index_to_remove][:quantity] - quantity_to_remove.to_i
      else
        puts('Enter valid quantity')
        return
      end
    else
      puts('enter valid index')
      return
    end
    total = 0
    @user_cart.each do |product|
      total += (product[:price] * product[:quantity])
      puts(total)
    end
  end
  
  # it is called from menu.rb(user_menu)
  # nothing just iterated products of (@user_cart)
  
  def view_cart
    puts "Available products in your cart are:\n"
    @user_cart.uniq.each_with_index do |product, index|
      puts "#{index + 1}. #{product[:name]} - Quantity: #{product[:quantity]} - Price per item: $#{product[:price]} - Total: $#{product[:quantity].to_i * product[:price].to_i}"
    end
  end
  
  def order_history
    if @shipping_details.empty?
      puts "You've not ordered anything yet"
    else
      puts "The Products that you recently ordered are:\n"
      @shipping_details.each_with_index do |order, index|
        puts "#{index + 1}. #{order.product_name} - $#{order.price}  - $#{order.total}- #{order.quantity} - #{order.address}\n"
      end
    end
  end
  
  # it is called from menu.rb(user_menu)
  # it call's (remove_from_cart) if we want to remove any product
  
  def checkout(current_user)
    user_reciever = current_user
    # puts"#{user_reciever}"
    if @user_cart.empty?
      puts("Please add Products in your Cart to Checkout\n")
    else
      view_cart
      loop_runner = true
      while loop_runner
        puts
        puts("Do you want to remove any Product\n")
        puts('1.Yes')
        puts('2.No')
        puts('3.Exit')
        puts('Please enter index for further operations !!!')
        choice = put_and_get('Enter Choice').chomp.to_i
        puts
        next unless choice.between?(1, 3)
        
        case choice
        when 1
          product_to_remove = put_and_get("Enter Index of the product you want to remove from your Cart\n").to_i
          quantity_to_remove = put_and_get("Enter quantity of the product you want to remove from your Cart\n").to_i
          remove_from_cart(product_to_remove, quantity_to_remove)
          view_cart
          return
        when 2
          if @user_cart.empty?
            puts 'Add product to your Cart'
            browse_product
          else
            puts "Enter your Details below to checkout the existing orders.\n"
            address = put_and_get("Enter Your Address\n")
            card_number = put_and_get("Enter Your Card Number\n")
            cvv = put_and_get("Enter Your CVV\n")
            if card_number.match(/^\d{16}$/) && cvv.match(/^\d{3}$/)
              @user_cart.each_with_index do |product, _index|
                @shipping_details.push(OrderDetails.new(user_reciever, product[:name],product[:price],product[:price] * product[:quantity],product[:quantity], address))
                end
                puts "Thanks for placing the Order #{user_reciever} ji,your order history is Given Below \n"
                order_history
                loop_runner = false
              else
                puts 'Invalid CVV or Card Number'
              end
            end
          when 3
            loop_runner = false
          end
        end
      end
    end
  end
  