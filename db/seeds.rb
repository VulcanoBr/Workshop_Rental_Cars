# Importa a gem Faker
require 'faker'
require 'json'

Faker::Config.default_locale = 'pt-BR'

def Subsidiary
  subsidiaria = [ "AlugueFácil Rent a Car", "LocaCar Veículos", "Veloz Aluguel de Carros",
                  "RentCar Express", "Roda Livre Aluguel de Automóveis"
                ]
  5.times do |index|
    subsidiary = Subsidiary.create!(
      name: subsidiaria[index],
      )
      Address.create!(
        street: Faker::Address.street_name,
        number: Faker::Address.building_number,
        complement: Faker::Address.secondary_address,
        neighborhood: Faker::Team.state,  #Faker::Address.community,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip_code,
        subsidiary_id: subsidiary.id
      )
      User.create(email: "manager#{subsidiary.id}@rental.com", password: "123456", 
                  subsidiary_id: subsidiary.id, role: :manager)
      User.create(email: "user#{subsidiary.id}@rental.com", password: "123456", 
                  subsidiary_id: subsidiary.id, role: :employee)
  end
end

def Users
  user = User.create!(email: 'admin@rental.com', password: '123456', 
                  subsidiary_id: Subsidiary.all.sample.id, role: :admin)
end

def Manufacture
  fabricantes_veiculos = [ "Toyota", "Volkswagen", "Honda", "Ford", "Kia", "BMW", "Mercedes-Benz", "Mitsubishi",
                            "Porsche", "Tesla", "Hyundai", "Nissan", "Subaru", "Audi", "Chevrolet", "Suzuki",
                            "Fiat", "Renault", "Peugeot", "Citroën"
                          ]
  20.times do |index|
    fabricante = fabricantes_veiculos[index]
    Manufacture.create!(name: fabricante)
  end
end

def CarModel
  year = Date.today.year
  modelos_carros = [
      "Fiat Strada", "Chevrolet Onix", "HB20", "Pulse", "Corolla", "Corolla Cross", "Limosine FX",
      "Fastback", "HB20S", "Montana", "208", "Virtus", "C3", "Duster", "S10", "Mustang", "Gol Fox",
      "Yaris HB", "Fiorino", "Yaris Sedan", "Ranger", "Spin", "Commander", "Hilux SW4", "Bronco XL",
      "Taos", "Tiggo 5x", "Oroch", "L200", "City", "City Hatch", "Haval H6", "Land Rover", "Eclipse SX",
      "Master", "Tiggo 8", "Versa", "Rampage", "Frontier", "Nivus", "Polo", "Voyage", "Vitara For You",
      "Cronos", "Toro", "Saveiro", "Compass", "T-Cross", "Kicks", "Maverick", "Ford 2000"
      ]
  100.times do |index|
    category = ["Standard", "Luxo", "Familia", "Special"]
    name = modelos_carros.sample  #modelos_carros[index]  modelos_carros[rand(modelos_carros.length)]
    car_options = Faker::Vehicle.car_options 
    carmodel = CarModel.create!(
          name: name, 
          year: Faker::Number.between(from: 2020, to: year),  #Faker::Date.between(from: 2020, to: Date.today).year,
          manufacture_id: Manufacture.all.sample.id, 
          car_options: car_options.join(", "),  # Faker::Vehicle.car_options 
          category: category.sample
        )
    sub = SubsidiaryCarModel.create!(
      price: Faker::Commerce.price(range: 250.0..950.0),  #Faker::Commerce.price,
      subsidiary_id: Subsidiary.all.sample.id,
      car_model_id: carmodel.id
    )
    Car.create!(
      car_model_id: carmodel.id,
      subsidiary_id: sub.subsidiary_id,
      car_km: Faker::Number.between(from: 100, to: 15000),
      color: Faker::Color.color_name,
      license_plate: Faker::Vehicle.license_plate,
      status: 0 
    )
  end
end
  
def Customers
  25.times do
    name3 = "Personal name" #Faker::Name.name || Faker::Name.bs
    email3 = "personal_email@email.com" #Faker::Internet.email
    Customer.create!(
      name: Faker::Name.name, # || Faker::Name.bs,
      email:Faker::Internet.email, # || Faker::Internet.bs,
      cpf: Faker::IDNumber.brazilian_citizen_number(formatted: true),
      phone: Faker::PhoneNumber.cell_phone,
      type: 'PersonalCustomer',
      cnpj: nil,
      fantasy_name: nil
    )
    name2 = Faker::Company.name
    email2 = "company_email@email.com"  #Faker::Internet.email
    Customer.create!(
      name: Faker::Company.name,
      email: Faker::Internet.email, # || Faker::Internet.bs,
      cpf: nil,
      phone: Faker::PhoneNumber.cell_phone,
      type: 'CompanyCustomer',
      cnpj: Faker::Company.brazilian_company_number(formatted: true),
      fantasy_name: Faker::Company.name
    )
  end
end

def Provider
  oficinas_carro = [ "AutoFix Garage", "Speedy Auto Service", "ProMechanic Workshop", "Express Car Care",
                    "Precision Auto Repair", "Reliable Motors Garage", "Apex Auto Solutions", "MasterWorks Automotive",
                    "GearUp Garage", "City Auto Clinic", "DriveTech Service Center", "FastLane Automotive",
                    "Elite Motors Workshop", "Ace Auto Tech", "FirstClass Car Care", "Summit Auto Specialists",
                    "Supreme Motors Maintenance", "GoldenWrench Automotive", "Platinum Performance Center",
                    "EagleEye Car Clinic", "Liberty Auto Care", "Victory Auto Service", "Diamond Edge Garage",
                    "Royal Auto Repairs", "Majestic Motors Workshop"
                  ]
  25.times do |index|
    oficina = oficinas_carro[index]
    Provider.create!(
      name: oficina,
      cnpj: Faker::Company.brazilian_company_number(formatted: true),
      email: Faker::Internet.email,  # || Faker::Internet.bs,
      phone: Faker::PhoneNumber.cell_phone
    )
  end
end


def Fines
  30.times do
    Fine.create!(
      issued_on: Faker::Date.between(from: '2020-03-23', to: Date.today),
      demerit_points: Faker::Number.between(from: 5, to: 15),
      fine_value: Faker::Commerce.price(range: 150.0..320.0),
      address: Faker::Address.full_address,
      car_id: Car.all.sample.id
    )
  end
end

def Maintenance
  30.times do
    Maintenance.create!( 
      car_id: Car.all.sample.id,
      provider_id: Provider.all.sample.id,
      invoice: Faker::Invoice.reference,
      service_cost: Faker::Commerce.price(range: 850.0..6520.0),
      maintenance_date: Faker::Date.between(from: '2020-05-23', to: Date.today)
    )
  end
end

def Rentals
  150.times do
    car = Car.all.sample
    car_model_id = car.car_model_id
    date_start = Faker::Date.between(from: '2020-02-01', to: Date.today)
    date_end = date_start + rand(2..15)
    subsidiary_car_model = SubsidiaryCarModel.find_by(car_model_id: car_model_id)
      Rental.create!(
        rented_code: date_start.year.to_s + SecureRandom.alphanumeric(11).upcase,
        car_id: car.id,
        user_id: User.all.sample.id,
        customer_id: Customer.all.sample.id,
        daily_price: subsidiary_car_model.price,
        start_at: nil,
        finished_at: date_end,
        status: 10,
        scheduled_start: Date.today,
        scheduled_end: Date.today + 5,
        started_at: date_start,
        ended_at: date_end
      )
  end
end


Address.destroy_all
SubsidiaryCarModel.destroy_all
Rental.destroy_all
Maintenance.destroy_all
Fine.destroy_all
Car.destroy_all
Subsidiary.destroy_all
User.destroy_all
CarModel.destroy_all
Manufacture.destroy_all
Customer.destroy_all
Provider.destroy_all

Subsidiary()
Users()
Manufacture()
CarModel()
Customers()
Provider()
Fines()
Maintenance()
Rentals()