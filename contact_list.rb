
require_relative 'contact'


# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.


  class << self

    def check_arguments
      if ARGV.empty?
        puts "Here's a list of available commands:"
        puts "\tnew\t - Create a new contact"
        puts "\tlist\t - List all contacts"
        puts "\tshow\t - show a contact"
        puts "\tsearch\t - search contacts"
        return false
      end
      true
    end  

    def list_contacts(contacts)
      
      contacts.each do |contact|
        puts "#{contact.id}: #{contact.name} (#{contact.email})"
  
      end
    end

    def get_contact_info
      
      contact = {}

      puts "Please enter the name of the contact"
      contact[:name] = $stdin.gets.chomp

      puts
      puts "Please enter the e-mail of the contact"
      contact[:email] = $stdin.gets.chomp 

      contact
    end

    def run_command
      case ARGV[0].downcase
      when 'new'
        contact = get_user_info
        Contact.create(contact[:name], contact[:email])
        
      when 'list'
        puts "List all the the contacts"
        list_contacts(Contact.all)
      when 'show'
        if contact = Contact.find(ARGV[1].to_i)
          list_contacts(contact)
        else  
          puts "Contact could not be found: please provide a valid id"
        end
        
      when 'search'
        contact = Contact.search(ARGV[1])
        if contact 
          list_contacts(contact)
        else
          puts "Your search did not match any records"
        end

      when 'update'
        if contact = Contact.find(ARGV[1].to_i)
          puts "Here's the contact that will be updated"
          list_contacts(contact)
          puts "Please, enter the new contact information"
          puts
          contact_info = get_contact_info
          Contact.update(contact, contact_info[:name], contact_info[:email])
        else
          puts "That contact cannot be found. A new contact will be created"
          contact_info = get_contact_info
          Contact.create(contact[:name], contact[:email])
        end

      when 'destroy'
        if contact = Contact.find(ARGV[1].to_i)
          Contact.destroy(contact)
        else
          puts "The contact is not in the contact list"
        end
      #end

      end 
    
    end 
  end 
end 

ContactList.run_command if ContactList.check_arguments


  

