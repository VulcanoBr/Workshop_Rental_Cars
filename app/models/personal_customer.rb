class PersonalCustomer < Customer
  validates :cpf, presence: true, cpf: true, uniqueness: true

  validates :cpf, length: { is: 14 }
  validates_format_of :cpf, with: /\A\d{3}\.\d{3}\.\d{3}-\d{2}\z/, 
                      message: "não está no formato correto (999.999.999-99)"

  def personal_customer?
    true
  end

  def company_customer?
    false
  end
end
