module LoginRegis
    require 'io/console'
    require_relative 'admin_operation'
    
    #this method is for if user hit enter key without giving any input
    def put_and_get(msg)
      max_attempts = 3
      attempts = 0
      loop do
        puts msg
        input = gets.chomp.strip
        unless input.empty?
          return input
        end
        attempts += 1
        if attempts >= max_attempts
          puts "You have entered an empty input #{max_attempts} times. Please try again"
          exit
        end
      end
    end
    # this method if for printing "*" if we're entering 
    # password but validation is remaining it is taking
    # backspace also as a input
    def get_password(msg)
      puts(msg)
      password = ""
      loop do
        char = STDIN.getch
        break if char == "\n" || char == "\r"
        if char == "\b" || char.ord == 127
          password.chop!
          print("\b \b")
        else
          print '*'
          password << char
        end
      end
      puts "\n"
      return password
    end
  end
  