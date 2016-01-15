public class StoryService{
    
    public static Integer MOST_RECENT_RECORD_COUNT = 5;
    
    public Story__c createStory(Story__c story){
    	if(story == null){
    		throw new ServiceException(Label.Required_Story);
    	}
        insert story;
        return story;
    }
    
    public Story__c updateStory(Story__c story){
    	if(story == null || story.Id == null){
    		throw new ServiceException(Label.Required_Story_Story_Id);
    	}
        update story;
        return story;
    }
    
    public List<Story__c> getMostRecentlyEnteredStories(){
        return Database.query('Select ' + ServiceUtility.getObjectFields(Story__c.SobjectType)+ ' from Story__c order by LastModifiedDate desc limit: MOST_RECENT_RECORD_COUNT');
    }
    
    public List<Story__c> getMostRecentlyEnteredStories(Integer mostRecentNRecords){
    	if(mostRecentNRecords == null){
    		throw new ServiceException(Label.Required_Most_Recent_Number_Record);
    	}
        return Database.query('Select ' + ServiceUtility.getObjectFields(Story__c.SobjectType)+ ' from Story__c order by LastModifiedDate desc limit: mostRecentNRecords');
    }
    
    public List<Activity__c> getActivities(Story__c story){
    	if(story == null || story.Id == null){
    		throw new ServiceException(Label.Required_Story_Story_Id);
    	}
    	String storyId = story.Id;
        return Database.query('Select ' + ServiceUtility.getObjectFields(Activity__c.SobjectType)+ ' from Activity__c where User_Story__c =: storyId');
    }
    
    public List<Story__c> search(List<Skills__c> skills){
    	if(skills == null || skills.size() == 0){
    		throw new ServiceException(Label.Required_Skills);
    	}
    	Set<Id> storyIds = new Set<Id>();
    	for(ActivitySkills__c activitySkill: [Select Id, Activity__c, Activity__r.User_Story__c from  ActivitySkills__c where Skill__c in: skills]){
    		storyIds.add(activitySkill.Activity__r.User_Story__c);
    	}
    	return Database.query('Select ' + ServiceUtility.getObjectFields(Story__c.SobjectType)+ ' from Story__c where Id in: storyIds');
    }
    
    public List<Story__c> getStoriesForUser(User user){
    	if(user == null || user.Id == null){
    		throw new ServiceException(Label.Required_User_User_Id);
    	}
    	Set<Id> storyIds = new Set<Id>();
    	for(MemberActivityMilestone__c memberActivityMilestone: [Select Id, Activity__c, Activity__r.User_Story__c from  MemberActivityMilestone__c where User__c =: user.ID]){
    		storyIds.add(memberActivityMilestone.Activity__r.User_Story__c);
    	}
    	String userId = user.Id; 
    	return Database.query('Select ' + ServiceUtility.getObjectFields(Story__c.SobjectType)+ ' from Story__c where Id in: storyIds or Publisher__c =: userId');
    }
}