Feature: Assignments
As an Admin
I want to be able to define assigments roles
So TLs can evaluate the rest of the teams members experience

Scenario: Assign roles
Given that I have a project A
And project A has members John and Mary 
When I look for projects without roles
Then I should see project A 
And John and Mary as members
