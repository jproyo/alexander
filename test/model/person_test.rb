require_relative 'model_test_module'


class TestPerson < Test::Unit::TestCase

	include ModelTestModule

	def test_new_person_is_not_leader
		assert !Person.new.is_leader
	end

	def test_person_without_leader_assignment_is_not_leader
		person = Person.new
		person.project_assignments << ProjectAssignment.new 
		assert !person.is_leader 
	end

	def test_person_with_at_least_one_leader_assignment_is_leader 
		person = Person.new

		projectAssignment = ProjectAssignment.new
		projectAssignment.is_leader = true

		person.project_assignments << projectAssignment

		assert person.is_leader
	end

	

end
