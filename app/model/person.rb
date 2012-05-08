class Person
  include DataMapper::Resource

  property :user_name, String, :key => true
  property :first_name, 		String
  property :last_name,	String
    
end
