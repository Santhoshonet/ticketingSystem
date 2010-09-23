class Usermailer < ActionMailer::Base
           default_url_options[:host] = "ticketsytem.heroku.com"

  def accountcreation(user)

    setup_email(user)

    @subject = "An account has been created at support.itxsolutionsindia.com"

    @user_mail = user

  end

  def newticketautoresponse(user,ticket)

    setup_email(user)

    @subject = "Request received: #{ticket.title.to_s[0,20]}...."

    @newticket = ticket
    
  end

  def newcommentalert(comment)

    @mails = []

    Comment.find(:all,:conditions => {:ticket_id => comment.ticket.id }).each do |cmt|
      @mails.push(cmt.user.email)
    end

    setup_email(comment.user)

    User.find(:all,:conditions => {:id => comment.ticket.created_by}).each do |user|
        @mails.push(user.email)
    end

    User.find(:all,:conditions => {:id => comment.user.id}).each do |user|
        @mails.delete(user.email)
    end

    @recipients = ''

    @mails.uniq.each do |ml|
       @recipients = ',#{ml}'
    end

    @addedcomment = comment

    @subject = comment.ticket.title

  end


  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "support@itxsolutionsindia.com"
      @sent_on     = Time.now
      @body[:user] = user
    end

end
