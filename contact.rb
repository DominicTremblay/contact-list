require 'byebug'
require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact

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

  # Provides functionality for managing contacts in the csv file.
  class << self


    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # TODO: Return an Array of Contact instances made from the data in 'contacts.csv'.

      contacts = []

      CSV.foreach(FILE_NAME) do |row|
        contacts.push(Contact.new(row[0],row[1],row[2]))
      end

      contacts

    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email)
      # TODO: Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      
      id = IO.readlines(FILE_NAME).last(1)[0].split(',')[0].to_i + 1
      
      contact = Contact.new(id.to_s, name, email)
      
      row_array = [contact.id, contact.name, contact.email]

      CSV.open(FILE_NAME, 'a') do |csv_object|
      #customers.array.each do |row_array|
          csv_object << row_array
        
      end
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # TODO: Find the Contact in the 'contacts.csv' file with the matching id.
      CSV.foreach(FILE_NAME, converters: :numeric) do |row|
        return row if row[0] == id
      end
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
