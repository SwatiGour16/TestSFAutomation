@isTest
public class StoryServiceTest{
	
	private static TestMethod void createStoryTest(){
		Story__c story = TestClassUtility.getStoryInstance();
		StoryService storyServiceImp = new StoryService();
		Test.startTest();
		Story__c newStory = storyServiceImp.createStory(story);
		Test.stopTest(); 
		System.assertNotEquals(null, newStory.Id);
	}
	
	private static TestMethod void updateStoryTest(){
		Story__c story = TestClassUtility.getStoryInstance();
		insert story;
		story.Description__c = 'Test123';
		StoryService storyServiceImp = new StoryService();
		Test.startTest();
		Story__c updatedStory = storyServiceImp.updateStory(story);
		Test.stopTest(); 
		System.assertEquals('Test123', [Select Description__c from story__c where id =: updatedStory.Id][0].Description__c);
	}
	
	private static TestMethod void getMostRecentlyEnteredStoriesWithoutParamTest(){
		List<Story__c> stories = new List<Story__c>();
		for(Integer i = 0; i < 100; i++){
			stories.add(TestClassUtility.getStoryInstance());
		}
		insert stories;
		StoryService storyServiceImp = new StoryService();
		Test.startTest();
		List<Story__c> recentStories = storyServiceImp.getMostRecentlyEnteredStories();
		Test.stopTest(); 
		System.assertNotEquals(0, recentStories.size());
	}
	
	private static TestMethod void getMostRecentlyEnteredStoriesWithParamTest(){
		List<Story__c> stories = new List<Story__c>();
		for(Integer i = 0; i < 100; i++){
			stories.add(TestClassUtility.getStoryInstance());
		}
		insert stories;
		StoryService storyServiceImp = new StoryService();
		Test.startTest();
		List<Story__c> recentStories = storyServiceImp.getMostRecentlyEnteredStories(10);
		Test.stopTest(); 
		System.assertEquals(10, recentStories.size());
	}
	
	private static TestMethod void getActivitiesTest(){
		Story__c story = TestClassUtility.getStoryInstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		StoryService storyServiceImp = new StoryService();
		Test.startTest();
		List<Activity__c> activities = storyServiceImp.getActivities(story);
		Test.stopTest(); 
		System.assertNotEquals(0, activities.size());
	}
	
	 private static TestMethod void searchTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		TestClassUtility.addSkills(activity, TestClassUtility.createSkills());
		StoryService storyServiceImp = new StoryService();
		Test.startTest();
		List<Story__c> searchedStories = storyServiceImp.search([select id from Skills__c]);
		Test.stopTest();      
		System.assertEquals(1, searchedStories.size());
    }
    
    private static TestMethod void getStoriesForUserTest(){
    	Story__c story = TestClassUtility.getStoryinstance();
		insert story;
		Activity__c activity = TestClassUtility.getActivityInstance(story.Id);
		insert activity;
		StoryService storyServiceImp = new StoryService();
		new ActivityService().setMilestones(TestClassUtility.createMilestones(), activity);
		TestClassUtility.createMemberActivity(activity, [Select Id from ActivityMilestones__c where Activity__c =: activity.Id][0]);
		Test.startTest();
		List<Story__c> stories = storyServiceImp.getStoriesForUser(new User(Id = UserInfo.getUserId()));
		Test.stopTest();      
		System.assertEquals(story.Id, stories[0].Id);
    }
    

}