require 'faker'
require 'csv'
require 'date'

class Person
    attr_accessor :first_name, :last_name, :email, :phone
    attr_reader   :created_at

    def initialize(first_name, last_name, email, phone, created_at)
        @first_name = first_name
        @last_name  = last_name
        @email      = email
        @phone      = phone
        @created_at = created_at
    end
end#class Person

def person_num(num)
    people = []
    for i in 1..num
        first_name  = Faker::Name.first_name
        last_name   = Faker::Name.last_name
        email       = Faker::Internet.free_email
        phone       = Faker::PhoneNumber.phone_number
        created_at  = Faker::Time.forward(23, :morning) # => "2014-09-26 06:54:47 -0700"
        people << Person.new(first_name, last_name, email, phone, created_at )
    end
    people
end#mtd person_num


class PersonWriter
    def initialize(file_name, people)
        @file   = file_name
        @people = people
    end#initialize

    def create_csv
        CSV.open(@file, "wb") do |csv|
            @people.each do |person|
                csv << [person.first_name, person.last_name, person.email, person.phone, person.created_at]
            end#people each
        end#CSV
    end#mtd create_csv

end#class PersonWriter

people = person_num(10)


person_writer = PersonWriter.new("people.csv", people)
person_writer.create_csv


class PersonParser
    def initialize(file_name)
        @file = file_name
    end#initialize

    def people
        people = []
        CSV.foreach(@file) do |row|
            date = DateTime.parse(row[4])
            people << Person.new(row[0], row[1], row[2], row[3], date)
        end#CSV
        people
    end#mtd people

end#class PersonParser


parser = PersonParser.new('people.csv')
people = parser.people

people.each do |person|
  p person
end

puts "\n"
puts "#{people[0]} #{people[0].first_name} #{people[0].last_name} #{people[0].email} *#{people[0].phone}* #{people[0].created_at}"











