class EmailIntegrationController < ApplicationController

  def read


     begin

        username = "santhosh@itxsolutionsindia.com"
        password = "password@123"

        gmail = Gmail.new(username,password)

        gmail.inbox.emails(:unread).each do |mails|


          mail =  mails.message

          ml = TMail::Mail.parse(mail)

          tickets = Ticket.find(:all,:conditions => "subject = #{ml.subject}")

          if tickets.empty? || tickets.count == 0

              ticket = Ticket.new

              ticket.title = ml.subject
              ticket.contact_id = 1
              ticket.group_id = 1
              ticket.status_id = 3
              ticket.priority_id = 3
              ticket.created_by = 1

              ticket.save

          end


          mail.mark(:read)


        end

        gmail.logout

      rescue Exception => ex
        puts "error while saving ticket from support@itxsolutionsindia.com doe to " + ex.message
      ensure
         sleep(300)
      end


  end

end
