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

              sender = User.find(:all,:conditions => "email = '#{ml.from[0].to_s}'")

              if sender.count == 0

                  newuser = User.new({
                    :username => "username23",
                    :password => 'support@itx',
                    :password_confirmation => 'support@itx',
                    :email => ml.from[0].to_s,
                    :email_confirmation => ml.from[0].to_s,
                    :first_name => ml.from[0].to_s,
                    :last_name => ml.from[0].to_s
                  })

                  index = 0
                  while !newuser.valid?
                    index += 1
                    newuser.username = "user" + rand(10000).to_s
                    if index >= 100
                      unless newuser.valid?
                        newuser.errors.each {|k, v| puts "#{k.capitalize}: #{v}"}
                      end
                      break;
                    end
                 end

                 newuser.save

                Usermailer.deliver_accountcreation(newuser)

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

              if ticket.valid?

                  ticket.save
                  
                  Usermailer.deliver_newticketautoresponse(newuser,ticket)

              else

                  ticket.errors.each {|k,v| puts "#{k.capitalize}: #{v}" }
                
              end


          else

             sender = User.find(:all,:conditions => "email = '#{ml.from[0].to_s}'")

             newuser = User.new
              
             if sender.count == 0

                newuser = User.new({
                  :username => "username23",
                  :password => 'support@itx',
                  :password_confirmation => 'support@itx',
                  :email => ml.from[0].to_s,
                  :email_confirmation => ml.from[0].to_s,
                  :first_name => ml.from[0].to_s,
                  :last_name => ml.from[0].to_s
                })

                index = 0
                while !newuser.valid?
                  index += 1
                  newuser.username = "user" + rand(10000).to_s
                  if index >= 100
                    unless newuser.valid?
                      newuser.errors.each {|k, v| puts "#{k.capitalize}: #{v}"}
                    end  
                    break;
                  end
                end

                newuser.save

                Usermailer.deliver_accountcreation(newuser)

             else

               newuser = sender[0]
               
             end

              tickets.each do |tkt|

                  comment = Comment.new

                  comment.comment = ml.body

                  comment.ticket = tkt

                  comment.user = newuser

                  if comment.valid?

                      comment.save

                      Usermailer.deliver_newcommentalert(comment)

                  else

                      comment.errors.each {|k,v| puts "#{k.capitalize}: #{v}"}

                  end


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

