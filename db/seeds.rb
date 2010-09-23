# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

Group.create :name => 'Accounting'
Group.create :name => 'Human Resources'
Group.create :name => 'Management'
Group.create :name => 'Marketing'
Group.create :name => 'Operations'
Group.create :name => 'Development'
Group.create :name => 'Sales'

# Do not delete 'open' and 'closed' statuses...those are required
Status.create :name => 'Open'
Status.create :name => 'Closed'
Status.create :name => 'Re-opened'
Status.create :name => 'Hold'
Status.create :name => 'Unresolved'

Priority.create :name => 'High'
Priority.create :name => 'Medium'
Priority.create :name => 'Low'

user_attrs = {
  :username => 'admin',
  :password => 'welcome',
  :password_confirmation => 'welcome',
  :email => 'admin@mycompany.com',
  :email_confirmation => 'admin@mycompany.com',
  :first_name => 'The',
  :last_name => 'Admin',
  :time_zone => 'Central Time (US & Canada)'
}
User.create(user_attrs)


contact_attrs = {
  :first_name => "ITX solutions",
  :last_name => "support",
  :email => "support@itxsolutionsindia.com",
  :mobile_phone => "+91 9962156705",
  :office_phone => "+91 044 64998328",
  :notes => "drop a mail to support@itxsolutionsindia.com to create a support ticket."
}

Contact.create(contact_attrs)

# allow admin to have admin rights
admin = User.find(1)
admin.admin = true
admin.save
