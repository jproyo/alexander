require "rack/test"

require "config/config"
require "main_controller"
require "rspec"

describe "SkillHub Main" do
  include Rack::Test::Methods

  def app
    SkillHub::Main.new
  end

  describe "Main API" do
     describe "POST /skills" do
      it "creates a new skill" do
        post "/skills/new", params={
          :description => 'desc', 
          'level-1' => 'l1',
          'level-2' => 'asdasdas',
          'level-3' => 'dasdasdadsa',
          :name => "S1"}

        last_response.status.should == 303
        Skill.all(:name => "S1").should have(1).items
      end
    end
  end
end

