require_relative 'contact'





# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.


  class << self

    def check_arguments
      if ARGV.size != 1
        puts "Here's a list of available commands:"
        puts "\tnew\t - Create a new contact"
        puts "\tlist\t - List all contacts"
        puts "\tshow\t - show a contact"
        puts "\tsearch\t - search contacts"
      else
        run_command
      end
    end  

    def list_contacts(contacts)
      
      contacts.each_with_index do |contact, idx|
        puts "#{idx}: #{contact.name} (#{contact.email})"
        
      end
    end

    def run_command
      case ARGV[0].downcase
      when 'new'
        puts "Create a new contact"
        #Contact.create(name,email)
      when 'list'
        puts "List all the the contacts"
        list_contacts(Contact.all)
      when 'show'
        puts "show one contact"
        #Contact.find(id)
      when 'search'
        puts "search contacts"
        #Contact.search(term)
      end
    end



  end



end

ContactList.check_arguments


  

