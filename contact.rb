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
      @@conn.exec('SELECT * FROM contacts ORDER BY id;') do |results|
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

    def update(contact, new_name, new_email)
      id = contact[0].id.to_i
      @@conn.exec_params("UPDATE contacts SET name=$1, email=$2 WHERE id=$3;", [new_name, new_email, id])
    end

    def create(name, email)
      id = save(name,email)
      Contact.new(id.to_i, name, email)    
    end
    
    def find(id)
      begin
        contact = @@conn.exec_params('SELECT * from contacts WHERE id=$1::int',[id])
        [Contact.new(contact[0]["id"], contact[0]["name"],contact[0]["email"])]        
      rescue
        nil
      end
    end

    def search(term)
      contacts = []
        @@conn.exec_params("SELECT * FROM contacts WHERE NAME ILIKE $1",["%#{term}%"]) do |results|
            results.map do |contact|      
              contacts.push(Contact.new(contact["id"].to_i,contact["name"],contact["email"]))
            end
        end
      contacts.empty? ? nil : contacts 
    end

    def destroy (contact)
      @@conn.exec_params('DELETE FROM contacts WHERE id = $1::int',[contact[0].id.to_i]) 
    end

  end
end
