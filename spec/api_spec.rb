require "rack/test"

require "config/config"
require "api_controller"
require "rspec"

describe "SkillHub API" do
  include Rack::Test::Methods

  def app
    SkillHub::Api.new
  end

  describe "Skills API" do
    def newskill name
      levels = ["low", "med", "high"].to_enum(:each_with_index).collect do |l, i|
        SkillLevel.create :name => l, :description => l, :index => (i + 1)
      end
      Skill.create :description => "desc", :name => name, :levels => levels
    end

    def newProject name
      Project.create :project_name => name
    end

    before :each do
      @skill = {
        "name" => "Nombre",
        "description" => "La desc",
        "main" => nil,
        "levels" => [
          {"index" => 1, "name" => "Low" , "description" => "La low"},
          {"index" => 2, "name" => "Med" , "description" => "La Med"},
          {"index" => 3, "name" => "High", "description" => "La Hig"},
        ]
      }
    end

    describe "GET /skills" do
      it "returns array of skills" do
        newskill "Nombre"
        newskill "Nombre2"

        get "/skills"
        (JSON.parse last_response.body).collect {|s| s["name"]}.should == ["Nombre", "Nombre2"]
      end

      it "returns [] when no skills are present" do
        get "/skills"
        last_response.body.should == [].to_json
      end

      it "can return an specific skill" do
        id = (newskill "Skill").id

        get "/skills/#{id}"        
        last_response.ok?.should be_true
        (JSON.parse last_response.body)["name"].should == "Skill"
      end
    end

    describe "POST /skills" do
      it "creates a new skill" do
        post "/skills", @skill.to_json
        last_response.header['Location'].should match /\/api\/skills\/\d*/

        @skill['id'] = last_response.header['Location'].split("/")[-1].to_i
        get "/skills/#{@skill['id']}"

        JSON.parse(last_response.body).should == @skill
      end
    end

    describe "DELETE /skills" do
      it "deletes a new skill" do
        id = (newskill "Skill1").id

        delete "/skills/#{id}"
        last_response.ok?.should be_true        

        get "/skills/#{@skill['id']}"
        last_response.ok?.should be_false        
      end

      it "is idempotent" do
        delete "/skills/789"
        last_response.ok?.should be_true
      end
    end

    describe "PUT /skills" do
      it "can update a single filed of an exising skill" do
        skill = newskill "Skill"
        id = skill.id

        put "/skills/#{id}", {"name" => "NewSkill"}.to_json
        last_response.ok?.should be_true

        get "/skills/#{id}"        
        response = JSON.parse last_response.body
        response['name'].should == "NewSkill"
        response['description'].should == "desc"
        response['levels'].should have(3).items
      end

      it "can update multiple all fields an exising skill, but only level desc is updated" do
        skill = newskill "Skill"
        id = skill.id

        put "/skills/#{id}", @skill.to_json
        last_response.ok?.should be_true

        get "/skills/#{id}"        
        response = JSON.parse last_response.body
        response.should == {
          "id" => id,
          "name" => "Nombre",
          "description" => "La desc",
          "main" => nil,
          "levels" => [
            {"index" => 1, "name" => "low" , "description" => "La low"},
            {"index" => 2, "name" => "med" , "description" => "La Med"},
            {"index" => 3, "name" => "high", "description" => "La Hig"},
          ]
        }
      end

      it "fails if there is no existing skill" do
        put "/skills/894", {"name" => "FakeSkill"}.to_json
        last_response.ok?.should be_false       
      end
    end

    describe "GET /projects/:id/unassignedSkills" do
      it "get all unassigned skills for a specific project" do
        skill1 = newskill "Skill1"
        skill2 = newskill "Skill2"
        skill3 = newskill "Skill3"
        id = (newProject "Project1").project_name

        get "/projects/#{id}/unassignedSkills"
        last_response.ok?.should be_true
        last_response.body.include?(skill1.to_json).should be_true
        last_response.body.include?(skill2.to_json).should be_true
        last_response.body.include?(skill3.to_json).should be_true

      end

      it "get not all skills for a specific project" do
        skill1 = newskill "Skill1"
        skill2 = newskill "Skill2"
        skill3 = newskill "Skill3"
        project = newProject "Project1"
        project.skills << skill1
        project.update
        id = project.project_name

        get "/projects/#{id}/unassignedSkills"
        last_response.ok?.should be_true
        last_response.body.include?(skill2.to_json).should be_true
        last_response.body.include?(skill3.to_json).should be_true
        last_response.body.include?(skill1.to_json).should be_false

      end
    end

    describe "GET /projects/:id/assignedSkills" do
      it "get all assigned skills for a specific project" do
        skill1 = newskill "Skill1"
        skill2 = newskill "Skill2"
        skill3 = newskill "Skill3"
        project = newProject "Project1"
        project.skills << skill1 << skill2
        project.update
        id = project.project_name

        get "/projects/#{id}/assignedSkills"
        last_response.ok?.should be_true
        last_response.body.include?(skill1.to_json).should be_true
        last_response.body.include?(skill2.to_json).should be_true
        last_response.body.include?(skill3.to_json).should be_false

      end

    end

    describe "GET /projects/:id/assign/skill/:skillId" do
      it "Assign a Specific Skill to a Specific Project" do
        skill1 = newskill "Skill1"
        project = newProject "Project1"

        project.skills.include?(skill1).should be_false

        get "/projects/#{project.project_name}/assign/skill/#{skill1.id}"
        last_response.ok?.should be_true
        Project.get(project.project_name).skills.include?(skill1).should be_true

      end

    end

    describe "GET /projects/:id/unassign/skill/:skillId" do
      it "Unassign a Specific Skill to a Specific Project" do
        skill1 = newskill "Skill1"
        skill2 = newskill "Skill2"
        project = newProject "Project1"
        project.skills << skill1
        project.update

        project.skills.include?(skill1).should be_true
        project.skills.include?(skill2).should be_false

        get "/projects/#{project.project_name}/unassign/skill/#{skill1.id}"
        last_response.ok?.should be_true
        Project.get(project.project_name).skills.include?(skill1).should be_false

      end

    end

  end
end

