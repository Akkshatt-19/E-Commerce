class Users
    attr_accessor :name, :number, :email,:password
    def initialize(name, number, email, password)
        @name = name
        @number =number
        @email = email
        @password = password
    end
end