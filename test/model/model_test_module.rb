require 'test/unit'
require 'data_mapper'
require 'model/person'
require 'model/project_assignment'


module ModelTestModule 

	def setup
        DataMapper.setup(:default, 'sqlite::memory:')
    end

	
end
