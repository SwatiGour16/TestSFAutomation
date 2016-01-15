/**
* This class tests the functionality of ActiveService class
*/
@isTest
public class ActivityServiceTest{
    
    private static TestMethod void createActivityTest(){
		Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		Activity__c newActivity = activityServiceImp.createActivity(activity);
		Test.stopTest();      
		System.assertNotEquals(null, newActivity.Id);
    }
    
    private static TestMethod void createActivityExceptionTest(){
		ActivityService activityServiceImp = new ActivityService();
		Boolean isException = false;
		Test.startTest();
		try{
			Activity__c newActivity = activityServiceImp.createActivity(null);
		}
		catch(Exception ex){
			isException = true;
		}
		Test.stopTest();      
		System.assertEquals(true, isException);
    }
    
    private static TestMethod void updateActivityTest(){
		Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity; 
		ActivityService activityServiceImp = new ActivityService();
		activity.Description__c = 'Test';
		Test.startTest();
		Activity__c updatedActivity = activityServiceImp.updateActivity(activity);
		Test.stopTest();      
		System.assertEquals('Test', [Select Description__c from Activity__c where Id =: updatedActivity.Id][0].Description__c);
    }
    
    private static TestMethod void deleteActivityTest(){
		Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		ActivityService activityServiceImp = new ActivityService();
		activity.Description__c = 'Test';
		Test.startTest();
		Activity__c deletedActivity = activityServiceImp.deleteActivity(activity);
		Test.stopTest();      
		System.assertEquals(0, [Select Id from Activity__c where Id =: deletedActivity.Id].size());
    }
    
    private static TestMethod void searchTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		TestClassUtility.addSkills(activity, TestClassUtility.createSkills());
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		List<Activity__c> searchedActivities = activityServiceImp.search([select id from Skills__c]);
		Test.stopTest();      
		System.assertEquals(1, searchedActivities.size());
    }
    
    private static TestMethod void getActivitiesForUserTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		ActivityService activityServiceImp = new ActivityService();
		activityServiceImp.setMilestones(TestClassUtility.createMilestones(), activity);
		TestClassUtility.createMemberActivity(activity, [Select Id from ActivityMilestones__c where Activity__c =: activity.Id][0]);
		Test.startTest();
		List<Activity__c> activities = activityServiceImp.getActivitiesForUser(new User(Id = UserInfo.getUserId()));
		Test.stopTest();      
		System.assertEquals(activity.Id, activities[0].Id);
    }
    
    private static TestMethod void setMilestonesTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Milestone__c> milestoneList = TestClassUtility.createMilestones();
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.setMilestones(milestoneList, activity);
		Test.stopTest();      
		System.assertNotEquals(0, [Select Id from ActivityMilestones__c where Activity__c =: activity.Id].size());
    }
    
    private static TestMethod void getMilestonesTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Milestone__c> milestoneList = TestClassUtility.createMilestones();
		TestClassUtility.createActivityMilestone(activity, milestoneList[0]);
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		List<Milestone__c> milestones = activityServiceImp.getMilestones(activity);
		Test.stopTest();      
		System.assertNotEquals(0, milestones.size());
    }
    
    private static TestMethod void addSkillsTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Skills__c> skills = TestClassUtility.createSkills();
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.addSkill(skills[0], activity);
		Test.stopTest();      
		System.assertEquals(1, [Select Id from ActivitySkills__c where Activity__c =: activity.Id and Skill__c =: skills[0].Id].size());
    }
    
    private static TestMethod void deleteSkillTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Skills__c> skills = TestClassUtility.createSkills();
		ActivityService activityServiceImp = new ActivityService();
		activityServiceImp.addSkill(skills[0], activity);
		Test.startTest();
		activityServiceImp.deleteSkill(skills[0], activity);
		Test.stopTest();      
		System.assertEquals(0, [Select Id from ActivitySkills__c where Activity__c =: activity.Id and Skill__c =: skills[0].Id].size());
    }
    
    private static TestMethod void getSkillsTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Skills__c> skills = TestClassUtility.createSkills();
		ActivityService activityServiceImp = new ActivityService();
		activityServiceImp.addSkill(skills[0], activity);
		activityServiceImp.addSkill(skills[1], activity);
		Test.startTest();
		List<Skills__c> resultSkills = activityServiceImp.getSkills(activity);
		Test.stopTest();      
		System.assertEquals(2, resultSkills.size());
    }
    
    private static TestMethod void getRequirementsTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Requirement__c> requirements = TestClassUtility.getRequirementsInstance(activity);
		insert requirements;
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		List<Requirement__c> resultRequirements = activityServiceImp.getRequirements(activity);
		Test.stopTest();      
		System.assertEquals(2, resultRequirements.size());
    }
    
    private static TestMethod void addRequirementsTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Requirement__c> requirements = TestClassUtility.getRequirementsInstance(activity);
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.addRequirements(requirements);
		Test.stopTest();      
		System.assertEquals(2, [Select Id from Requirement__c where Activity__c =: activity.Id].size());
    }
    
    private static TestMethod void updateRequirementsTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Requirement__c> requirements = TestClassUtility.getRequirementsInstance(activity);
		insert requirements;
		requirements[0].Description__c = 'Test 123';
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.updateRequirements(requirements[0]);
		Test.stopTest();      
		System.assertEquals('Test 123', [Select Description__c from Requirement__c where Id =: requirements[0].Id][0].Description__c);
    }
    
    private static TestMethod void deleteRequirementsTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Requirement__c> requirements = TestClassUtility.getRequirementsInstance(activity);
		insert requirements;
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.deleteRequirements(requirements);
		Test.stopTest();      
		System.assertEquals(0, [Select Id from Requirement__c where Activity__c =: activity.Id].size());
    }
    
    private static TestMethod void isLockedTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		List<Milestone__c> milestoneList = TestClassUtility.createMilestones();
		ActivityService activityServiceImp = new ActivityService();
		activityServiceImp.setMilestones(milestoneList, activity);
		Test.startTest();
		Boolean isLocked = activityServiceImp.isLocked(activity);
		Test.stopTest();      
		System.assertEquals(true, isLocked);
    }
    
    private static TestMethod void cloneActivityTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		insert TestClassUtility.getRequirementsInstance(activity);
		ActivityService activityServiceImp = new ActivityService();
		activityServiceImp.addSkill(TestClassUtility.createSkills()[0], activity);
		Award__c award = TestClassUtility.getAwardInstance(activity);
		insert award;
		Test.startTest();
		Activity__c newActivity = activityServiceImp.cloneActivity(activity);
		Test.stopTest();      
		System.assertNotEquals(0, [Select Id from Requirement__c where Activity__c =: activity.Id].size());
		System.assertNotEquals(0, [Select Id from ActivitySkills__c where Activity__c =: activity.Id].size());
		System.assertNotEquals(0, [Select Id from Award__c where Activity__c =: activity.Id].size());
    }
    
    private static TestMethod void addAwardTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		Award__c award = TestClassUtility.getAwardInstance(activity);
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.addAward(award);
		Test.stopTest();      
		System.assertEquals(1, [Select Id from Award__c where Activity__c =: activity.Id].size());
    }
    
    private static TestMethod void editAwardTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		Award__c award = TestClassUtility.getAwardInstance(activity);
		insert award;
		award.Payment__c = 200;
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.editAward(award);
		Test.stopTest();      
		System.assertEquals(200, [Select Id, Payment__c from Award__c where Activity__c =: activity.Id][0].Payment__c);
    }
    
    private static TestMethod void deleteAwardTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		Award__c award = TestClassUtility.getAwardInstance(activity);
		insert award;
		ActivityService activityServiceImp = new ActivityService();
		Test.startTest();
		activityServiceImp.deleteAward(award);
		Test.stopTest();      
		System.assertEquals(0, [Select Id from Award__c where Activity__c =: activity.Id].size());
    }
}