require 'sinatra/base'
require 'json'

module SkillHub

  # Api Controller
  class Api < Sinatra::Base

    def json_to_skill_levels(levels)
      levels.collect do |level|
        SkillLevel.create(
          :description => level['description'],
          :name => level['name'], ##TODO is ok that the user specifies the name?
          :index => level['index'])
      end  
    end 

    configure :production, :development do
      enable :logging
    end

    before do
      content_type :json
    end

    get '/persons' do
      Person.all(:order => [:user_name.asc]).to_json
    end

    post '/skills' do
      data = JSON.parse(request.body.read)
      levels = json_to_skill_levels data['levels']
      skill = Skill.create(
        :name => data['name'],
        :description => data['description'],
        :levels => levels)
      [ 201, {"Location" => "/api/skills/#{skill.id}"}, ""]
    end

    get '/skills/:id' do |id|
      skill = Skill.get(id)
      skill.to_json(:relationships => {:levels => {:exclude => [:id, :skill_id]}})
    end

    delete '/skills/:id' do |id|
      skill = Skill.get(id)
      skill.destroy_full unless skill.nil?
      [200]
    end

    put '/skills/:id' do |id|
      data = JSON.parse(request.body.read)
      skill = Skill.get(id)

      return [404] if skill.nil?

      ['name', 'description'].each do |property|
        skill.update(property => data[property]) unless data[property].nil?
      end
      unless data['levels'].nil? 
        data['levels'].each do |data_level|
          skill.update_level_description(data_level['index'], data_level['description'])
        end
      end
      [200]
    end

    #All Roles
    get '/roles' do
      Role.all.to_json
    end

    #Role's skills
    get '/roles/:role/skills' do |role|
      Skill.all(Skill.roles.id => role).to_json
    end

    #People
    get '/people' do
      Person.all(:order => [:unix_name.asc]).to_json
    end

    #Projects
    get '/projects' do
      Project.all.to_json
    end

    get '/projects/:id' do |project_id|
      project = Project.get(project_id)
      project.to_json(:relationships => {:skills => {}})
    end

    get '/projects/:id/unassignedSkills' do |project_id|
      skills = Skill.all
      project_skills  = Project.get(project_id).skills
      (skills - project_skills).to_json
    end

    get '/projects/:id/assignedSkills' do |project_id|
      return Project.get(project_id).skills.to_json
    end

    get '/projects/:id/assign/skill/:skillId' do |project_id, skill_id|
      skill = Skill.get(skill_id)
      project = Project.get(project_id)
      project.skills << skill 
      project.update
    end

    get '/projects/:id/unassign/skill/:skillId' do |project_id, skill_id|
      skill = Skill.get(skill_id)
      project = Project.get(project_id)
      project.skills.delete(skill)
      project.save
    end

    #Assigments
    get '/projects/:project/assigments' do |project_id|
      ProjectAssigment.all(ProjectAssigment.project.id => project_id).to_json
    end

    #Evaluations
    get '/evaluation/:evaluation' do |evaluation_id|
      project = ProjectEvaluationInstance.get(evaluation_id).project
      assigments = ProjectAssignment.all(:project => {:project_name => project.project_name})

      {
        "project" => project,
        "areas" => assigments.collect(&:area).uniq,
        "members" => assigments.collect {|assignment| {
          "name" => assignment.person.unix_name,
          "area" => assignment.area.name
        }}.uniq,
        "skills" => project.skills.collect {|skill| {
          "name" => skill.name,
          "description" => skill.description,
          "levels" => skill.skill_levels,
          "areas" => skill.areas.collect(&:name)
        }}
      }.to_json
    end

  end
end