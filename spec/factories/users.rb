# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name { "John Doe" }              
    email { "user@example.com" }           
    password { "password" }                 
    password_confirmation { password }      
    role { 0 }                          

    trait :admin do
      role { 1 }                          
    end

  end
end