heroku create ticketSystem
git push heroku master
heroku rake db:migrate
heroku rake db:seed