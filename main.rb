require 'io/console'
require_relative 'users'
require_relative 'menu'
require_relative 'admin_operation'
require_relative 'product'
BEGIN {
puts('Welcome to the Shopping Store!')
}

class Main
  menu = Menu.new
  while true
    puts
    puts('Main Menu:')
    puts('==================================================================')
    puts('1. Register an Account')
    puts('2. Log In')
    puts('3. Exit')
    puts
    print('Please enter your choice: ')
    choice = gets.chomp.to_i
    puts
    
    if choice.between?(1, 3)
      case choice
      when 1
        menu.add_account
      when 2
        menu.login_account
      when 3
        exit
      end
    else
      puts("Invalid Choice")
    end
  end
  
  END {
  puts('Thanks for using the Shopping Portal')
  puts('Have a good day!')
  puts('==================================================================')
}
end
Main.new