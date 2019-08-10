class Person < ActiveRecord::Base
  belongs_to :location
  belongs_to :role
  belongs_to :manager, class_name: "Person", foreign_key: :manager_id
  has_many :employees, class_name: "Person", foreign_key: :manager_id

  def self.maximum_salary_by_location
    group(:location_id).maximum(:salary)
  end

  def self.managers_by_average_salary_difference
    joins(
      "INNER JOIN (" + Person.select('manager_id, AVG(salary) avg_salary').group(:manager_id).to_sql + ") salaries " +
      "ON salaries.manager_id = people.id " +
      "ORDER BY people.salary - salaries.avg_salary DESC"
    )
  end
end
