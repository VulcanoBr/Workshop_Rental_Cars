class Customer < ApplicationRecord
  has_many :rentals, dependent: :destroy
  validates :name, :email, :phone, presence: true

  scope :search_by_name, ->(name) {
    where("lower(name) LIKE ?", "%#{name.downcase}%")
    .order('name')
  }

  scope :order_by_name, -> { order("name") }

  scope :customers_by_type, -> {
    stats_query = <<-SQL
      SELECT
        COUNT(*) AS total_customers,
        SUM(CASE WHEN type = 'PersonalCustomer' THEN 1 ELSE 0 END) AS total_personal,
        SUM(CASE WHEN type = 'CompanyCustomer' THEN 1 ELSE 0 END) AS total_company,
        ROUND((SUM(CASE WHEN type = 'PersonalCustomer' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS personal_percent,
        ROUND((SUM(CASE WHEN type = 'CompanyCustomer' THEN 1 ELSE 0 END) * 100.0) / COUNT(*), 2) AS company_percent
      FROM customers
    SQL

    find_by_sql(stats_query)
  }

  def description
    type == "PersonalCustomer" ? "#{name}  -  #{cpf}" : "#{name} - #{cnpj}"
  end

  def active_rental?
    rentals.exists?(status: ['scheduled', 'active'])
  end

end
