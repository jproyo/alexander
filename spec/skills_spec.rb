require "config/config"
require "rspec"

describe "Skill" do

  it "can create a skill with name and description" do
    skill = Skill.new_skill('S1', 'Skill1')
    skill.name.should == 'S1'    
    skill.description.should == 'Skill1'
    skill.levels.collect { |l| l.description }.should == ['-', '-', '-']
  end

  it "can create a skill with name and levels" do
    skill = Skill.new_skill('S1', 'Skill1', ['d1', 'd2', 'd3'])
    skill.name.should == 'S1'    
    skill.levels.collect { |l| l.description }.should == ['d1', 'd2', 'd3']
  end

  it "can update a skill description" do
    skill = Skill.new_skill('S1', 'Skill1', ['d1', 'd2', 'd3'])
    skill.update_level_description(2, 'D2')    
    skill.levels.collect { |l| l.description }.should == ['d1', 'D2', 'd3']
  end

  it "can delete a skill" do
    skill = Skill.new_skill('S1', 'Skill1', ['d1', 'd2', 'd3'])
    id = skill.id

    skill.destroy_full.should be_true

    Skill.get(id).should be_nil
  end
end