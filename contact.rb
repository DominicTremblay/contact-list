require 'byebug'
require 'csv'
require 'pg'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

  @@conn = PG.connect(
    host: 'localhost',
    dbname: 'postgres',
    user: 'development',
    password: 'development'
  )



  FILE_NAME = 'contacts.csv'

  attr_accessor :id, :name, :email
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(id, name, email)
    # TODO: Assign parameter values to instance variables.
      @id = id
      @name = name
      @email = email
  end
  
  class << self

    def all 
      @@conn.exec('SELECT * FROM contacts;') do |results|
        results.map do |contact|
          Contact.new(contact["id"].to_i,contact["name"],contact["email"])
        end
      end 
    end

    def save(name,email)
      @@conn.exec_params("INSERT INTO contacts (name, email) VALUES ($1, $2) RETURNING id;", [name, email]) do |results|
        results[0]["id"]
      end

    end

    def create(name, email)
      id = save(name,email)
      Contact.new(id.to_i, name, email)    
    end
    
    def find(id)
    
    end

    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # TODO: Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      contacts = []
      CSV.foreach(FILE_NAME) do |row| 
        row.each do |cell| 
          if /#{term}/.match(cell) 
            contacts.push(Contact.new(row[0], row[1], row[2]))
          end
        end
      end
      contacts
    end


  end

end
