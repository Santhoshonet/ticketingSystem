require "gmail"

class EmailIntegrationController < ApplicationController

  def read

     #begin
        
        username = "santhosh@itxsolutionsindia.com"
        password = "password@123"

        require "gmail"
        
        gmail = Gmail.new(username,password)
        

        gmail.inbox.emails(:unread).each do |mails|

         
          mail =  mails.message

          ml = TMail::Mail.parse(mail)

          tickets = Ticket.find(:all,:conditions => "mailrefid = '#{ml.message_id}'")

          if tickets.empty? || tickets.count == 0

              newuser = User.new

              sender = User.find(:all,:conditions => "email = '#{ml.from}'")

              if sender.count == 0

                  newuser.username = ml.from
                  newuser.password = "password"
                  newuser.password_confirmation = "password"
                  newuser.email = ml.from
                  newuser.email_confirmation = ml.from
                  newuser.first_name = ml.from
                  newuser.last_name = ml.from
                  newuser.time_zone= "(GMT+05:30) Chennai"

                  newuser.save

              else

                newuser = sender[0]

              end

              ticket = Ticket.new

              ticket.title = ml.subject
              ticket.contact_id = 1
              ticket.group_id = 1
              ticket.status_id = 1
              ticket.priority_id = 2
              ticket.created_by = newuser
              ticket.mailrefid = ml.message_id

              ticket.save

          else

             sender = User.find(:all,:conditions => "email = '#{ml.from}'")

              newuser = User.new
              
              if sender.count == 0

               newuser = User.new({
                  :username => "yourname",
                  :password => 'welcome',
                  :password_confirmation => 'welcome',
                  :email => "santhosh@gmail.com",
                  :email_confirmation => "santhosh@gmail.com",
                  :first_name => "santhosh",
                  :last_name => "santhosh"
                })

               puts newuser.save

               puts "user created"
                
              end

              tickets.each do |tkt|

                  comment = Comment.new

                  comment.comment = ml.body

                  comment.ticket = tkt

                  comment.user = newuser
                  
                  comment.save

              end


          end

          mails.mark(:read)

        end

        gmail.logout

      #rescue Exception => ex
      #  puts "error while saving ticket from support@itxsolutionsindia.com doe to " + ex.message
      #ensure
         #sleep(300)
      #end


  end

end

