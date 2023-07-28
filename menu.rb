require_relative 'login_regis'
require_relative 'admin_operation'
require_relative 'product'
require "csv"
class Menu
  attr_accessor :user
  # this is the regex validations for the EMAIL & NUMBER
  EMAIL_REGEX = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
  PHONE_NUMBER_REGEX = /^\(?[\d]{3}\)?[\s|-]?[\d]{3}-?[\d]{4}$/
  include LoginRegis
  def initialize
    @admin_op = AdminOperations.new
    @user = []
    @admin_id = 'admin'
    @admin_pwd = 'admin123@'
    @count = 0
  end
  
  # this (add_account) method is for creating the account 
  # and it stores the data in @user array so we can fetch
  # it during (managing user) in admin section
  
  def add_account
    name = put_and_get("Enter your username ")
    number = put_and_get("Enter your phone Number ")
    email = put_and_get("Enter your Email Address ")
    password = get_password("Enter Password\n")
    if(email.match(EMAIL_REGEX) && number.match(PHONE_NUMBER_REGEX)) #&&password.match(PASSWORD_REGEX))
      @user.push(Users.new(name,number,email,password))
      puts('User successfully Registered!')
    else
      @count=@count+1
      if(@count < 3)     
        puts "Invalid Email/Number try Entering the details again\n"
        add_account
      else
        puts "You've Exceeded the limit of Registering"
        exit
      end
    end
  end
  
  
  
  # PASSWORD_REGEX = /^[([a-z]|[A-Z])0-9_-]{6,40}$/
  
  
  # this method is called from (login_account) if it does not find's
  # the input for admin so basicaly this method is in the else part. 
  
  def validateuser(checku,checkp)
    @user.each do |user|
      if(user.name == checku && user.password == checkp)
        puts "Hello #{user.name} you're Successfully Logged In"
        user_menu(user.name)
      else
        puts 'Please try again'
      end
    end
  end
  
  # this method checks if the input we get is admin then it 
  # goes for admin_menu and if the user is not a admin then 
  # we're checking that the user is valid or not by passing  
  # variable in (validateuser) method.
  
  def login_account
    vname = put_and_get('Enter your Username ')
    vpwd = get_password('Enter Password')
    if(vname == @admin_id && vpwd == @admin_pwd)
      admin_menu("Admin Successfully Logged In")
    else
      validateuser(vname,vpwd)
    end
  end
  
  # this method is for user menu it is called 
  # if id and password of user is matched successfully
  # it is called through (validate_user) method
  
  def user_menu(current_user)   #object created to access
    loop_runner = true          #methods of Product class  
    while loop_runner
      puts
      puts("User Menu:")
      puts("==================================================================")
      puts("1.Browse Products")
      puts("2.Search Products")
      puts("3.Add to Cart")
      puts("4.View Cart")
      puts("5.Checkout")
      puts("6.View Order History")
      puts("7.Exit")
      puts
      puts('Where you want to Navigate')
      choice = gets.chomp.to_i
      puts
      if choice.between?(1,7)
        case choice
        when 1
          @admin_op.browse_products  
        when 2
          @admin_op.search_product
        when 3
          @admin_op.browse_products
          puts
          @admin_op.add_cart
        when 4
          @admin_op.view_cart
        when 5
          @admin_op.checkout(current_user)
        when 6
          @admin_op.order_history
        when 7
          loop_runner = false    #we've made loop_runner false here
        end                      #so we can go back to previous menu
      else
        puts("Invalid Choice")
      end
    end
  end
  
  # this method is called from (login_account) 
  # if input is same as for admin(pre-defined idp)
  
  def admin_menu(msg)
    puts(msg)
    loop_runner = true
    while loop_runner
      puts("Admin Menu:")
      puts
      puts("==================================================================")
      puts("1.Manage Products")
      puts("2.Manage Users")
      puts("3.Export Data")
      puts("4. Exit")
      puts
      print("Please enter your choice: ")
      ad_choice = gets.chomp.to_i
      puts
      if ad_choice.between?(1,4)
        case ad_choice
        when 1
          @admin_op.manage_products
        when 2
          manage_user
        when 3
          manage_data
        when 4
          loop_runner = false
        end
      else
        puts("Invalid Choice")
      end
    end
  end
  
  def manage_data
    loop_runner = true
    while loop_runner
      puts("Export Data Menu")
      puts
      puts('==================================================================')
      puts("1.Product's Data")
      puts("2.Users Data")
      puts("3.Order Data")
      puts("4.Exit")
      print("Please enter your choice: ")
      ad_choice = gets.chomp.to_i
      puts
      if ad_choice.between?(1,4)
        case ad_choice
        when 1
          @admin_op.export_products
        when 2
          export_user
        when 3
          @admin_op.export_orders
        when 4
          loop_runner = false
        end
      else
        puts("Invalid Choice")
      end
    end
  end

  # I have made this method for exporting the data of users.When admin add a user
  # or the user register by itself, the data was pushed in (@user) then if 
  # admin want to see the data he can export easily with the help of this method 
  # and then it is exported to (users.csv) file.It is called from manage data
  # which is in the same page

  
  def export_user
    if @user.empty?
      puts "No user is registered yet"
    else
      user_data = "Name,Number,Email,Password\n"
      @user.each do |user|
        user_data << "#{user.name},#{user.number},#{user.email},#{user.password}\n"
      end
      File.write('user.csv',user_data)
      puts "\tUser data has been Exported"
    end
  end
  
  def delete_user
    if @user.empty?
      puts "No user is registered yet"
    else
      @user.each_with_index do |user, index|
        puts "#{index+1}. #{user.name} #{user.number} #{user.email} #{user.password}"
      end
      input_from_admin = put_and_get("Do you want to remove any user ?\nYes or No")
      if(input_from_admin == 'yes' ||input_from_admin == 'Yes'||input_from_admin == 'YES')
        index_to_delete = put_and_get("Enter index of the user to delete account").to_i-1
        if index_to_delete.between?(0,@user.length-1)
          @user.delete_at(index_to_delete)
          puts "Deleted Successfully"
        else
          puts "Wrong Entry"
        end
      else
        admin_menu("Enter your Choice again")  
      end
    end
  end
  
  def update_user
    if @user.empty?
      puts "No user is registered yet"
    else
      @user.each_with_index do |user, index|
        puts "#{index + 1}. #{user.name} #{user.number} #{user.email} #{user.password}"
      end
      
      input_from_admin = put_and_get("Enter the index of the user to update account").to_i - 1
      
      if input_from_admin.between?(0, @user.length - 1)
        user_to_update = @user[input_from_admin]
        puts "Enter the updated details for user #{user_to_update.name}:"
        temp_name = put_and_get("Enter updated username")
        temp_number = put_and_get("Enter updated phone Number")
        temp_email = put_and_get("Enter updated Email Address")
        temp_password = get_password("Enter updated Password")

        if(temp_name.empty?||temp_number.empty?||temp_email.empty?||temp_password.empty?)
          puts"Field's can't be empty"
          return
        else
          user_to_update.name = temp_name
          user_to_update.number = temp_number
          user_to_update.email = temp_email
          user_to_update.password = temp_password
          puts "User details updated successfully!"
        end
      else
        puts "Wrong Entry"
      end
    end
  end
  
  #this method help admin to remove the user 
  #and it is called from admin menu when we want to manage the user
  #here @user is an array which holds data of every user 
  #and is defined inside initialize
  
  def manage_user
    loop_runner = true
    while loop_runner
      puts('Manage User Menu:')
      puts
      puts('==================================================================')
      puts('1.Add User')
      puts('2.Delete USer')
      puts('3.Update Users')
      puts('4. Exit')
      puts
      print('Please enter your choice: ')
      ad_choice = gets.chomp.to_i
      puts
      if ad_choice.between?(1,4)
        case ad_choice
        when 1
          add_account
        when 2
          delete_user
        when 3
          update_user
        when 4
          loop_runner = false
        end
      else
        puts("Invalid Choice")
      end
    end
  end
end
  