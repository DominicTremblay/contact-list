
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

    def create_contact
      
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
        
        puts "Create a new contact"
        contact = create_contact
        Contact.create(contact[:name], contact[:email])
        
      when 'list'
        puts "List all the the contacts"
        list_contacts(Contact.all)
      when 'show'
        contact = Contact.find(ARGV[1].to_i)
        if !contact.nil?
          list_contacts([Contact.new(contact[0], contact[1],contact[2])])
        else
          puts "Contact could not be found"
        end
      when 'search'
        puts "search contacts"
        list_contacts(Contact.search(ARGV[1]))
      end
    end
  end
end

ContactList.run_command if ContactList.check_arguments


  

