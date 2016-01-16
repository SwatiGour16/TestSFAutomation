/**
* This class perform different operation on Activity object
* Changed comments
*/
public class ActivityService{
	
    /**
    * This method creates activity
    * @param: activity object instance
    */
    public Activity__c createActivity(Activity__c activity){
    	if(activity == null){
    		throw new ServiceException(Label.Required_Activity);
    	}
        insert activity;
        return activity;
    }
    
    /**
    * This method updates activity
    * @param: activity object instance
    */
    public Activity__c updateActivity(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
        update activity;
        return activity;
    }
    
     /**
    * This method deletes activity
    * @param: activity object instance
    */
    public Activity__c deleteActivity(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
        delete activity;
        return activity;
    }
    
    /**
    * This method search activity of the passed skills
    * @param: List of Skills__c object 
    */
    public List<Activity__c> search(List<Skills__c> skills){
    	if(skills == null){
    		throw new ServiceException(Label.Required_Skills);
    	}
    	return Database.query('Select '+ServiceUtility.getObjectFields(Activity__c.SobjectType)+' from Activity__c where Id in (Select Activity__c from  ActivitySkills__c where Skill__c in: skills)');
    }
    
    /**
    * This method returns activities of the passed user who can be the member i.e. registered user or the publisher of activity
    * @param: User whose activities to be returned 
    */
    public List<Activity__c> getActivitiesForUser(User user){
    	if(user == null || user.Id == null){
    		throw new ServiceException(Label.Required_User_User_Id);
    	}
    	String userId = user.Id;
    	Set<Id> activityIds = new Set<Id>();
    	for(MemberActivityMilestone__c memberActivity: [Select Activity__c from  MemberActivityMilestone__c where User__c =: userId]){
    		activityIds.add(memberActivity.Activity__c);
    	}
    	return Database.query('Select '+ServiceUtility.getObjectFields(Activity__c.SobjectType)+' from Activity__c where (Id in: activityIds) or (Publisher__c =: userId)');
    }
    
    public void setMilestones(List<Milestone__c> milestoneList, Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	if(milestoneList == null || milestoneList.size() == 0){
    		throw new ServiceException(Label.Required_Milestone_List);
    	}
    	if(milestoneList != null && milestoneList.size() > 0 && activity != null && activity.Id != null){
    		List<ActivityMilestones__c> activityMilestoneList = new List<ActivityMilestones__c>();
	    	for(Milestone__c milestone: milestoneList){
	    		activityMilestoneList.add(new ActivityMilestones__c(Milestone__c = milestone.Id, Activity__c = activity.Id));
	    	}
	    	insert activityMilestoneList;
    	}
    }
    
    public List<Milestone__c> getMilestones(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	String activityId = activity.Id;
    	return Database.query('Select '+ServiceUtility.getObjectFields(Milestone__c.SobjectType)+' from Milestone__c where id in (Select Milestone__c from ActivityMilestones__c where Activity__c =: activityId)');
    }
    
    public void addSkill(Skills__c skill, Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	if(skill == null || skill.Id == null){
    		throw new ServiceException(Label.Required_Skill_Skill_Id);
    	}
    	ActivitySkills__c activitySkill = new ActivitySkills__c(Skill__c = skill.Id, Activity__c = activity.Id);
    	insert activitySkill;
    }
    
    public void deleteSkill(Skills__c skill, Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	if(skill == null || skill.Id == null){
    		throw new ServiceException(Label.Required_Skill_Skill_Id);
    	}
    	delete [Select Id from ActivitySkills__c where Skill__c =: skill.Id and  Activity__c =: activity.Id];
    }
    
    public List<Skills__c> getSkills(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	String activityId = activity.Id;
    	return Database.query('Select '+ServiceUtility.getObjectFields(Skills__c.SobjectType)+' from Skills__c where id in (Select Skill__c from ActivitySkills__c where Activity__c =: activityId)');
    }
    
    public List<Requirement__c> getRequirements(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	String activityId = activity.Id;
    	return Database.query('Select '+ServiceUtility.getObjectFields(Requirement__c.SobjectType)+' from Requirement__c where Activity__c =: activityId');
    }
    
    public void addRequirements(List<Requirement__c> requirements){
    	if(requirements == null || requirements.size() == 0){
    		throw new ServiceException(Label.Required_Requirements);
    	}
    	insert requirements;
    }
    
    public void updateRequirements(Requirement__c requirement){
    	if(requirement == null || requirement.Id == null){
    		throw new ServiceException(Label.Required_Requirement_Requirement_Id);
    	}
    	update requirement;
    }
    
    public void deleteRequirements(List<Requirement__c> requirements){
    	if(requirements == null || requirements.size() == 0){
    		throw new ServiceException(Label.Required_Requirements);
    	}
    	delete requirements;
    }
    
    public List<Default_Requirement__c> getDefaultRequirements(){
    	return Database.query('Select '+ServiceUtility.getObjectFields(Default_Requirement__c.SobjectType)+' from Default_Requirement__c Limit '+ServiceUtility.getSQLRowsLimit());
    	
    }
    
    public Boolean isLocked(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	boolean result = false;
    	List<ActivityMilestones__c> activityMilestones = [Select Id, Milestone__r.Due_Date__c 
    														from ActivityMilestones__c 
    														where Activity__c =: activity.Id 
    														and Milestone__r.Name =: ServiceUtility.REVIEW_DATE
    														and Milestone__r.Due_Date__c <: System.now()];
    	if(!activityMilestones.isEmpty()){
    		result = true;
    	}
    	return result;
    }
    
    public Activity__c cloneActivity(Activity__c activity){
    	if(activity == null || activity.Id == null){
    		throw new ServiceException(Label.Required_Activity_Activity_Id);
    	}
    	System.SavePoint sp = Database.setSavepoint();
    	String activityId = activity.Id;
    	Activity__c newActivity;
    	try{
	    	List<Activity__c> activityList = Database.query('Select '+ServiceUtility.getObjectFields(Activity__c.SobjectType)+' from Activity__c where Id =: activityId');
	    	if(!activityList.isEmpty()){
	    		newActivity = activityList[0].clone();
	    		insert newActivity;
	    		List<Award__c> newAwardList = new List<Award__c>();
	    		for(Award__c award: Database.query('Select '+ServiceUtility.getObjectFields(Award__c.SobjectType)+' from Award__c where Activity__c =: activityId')){
	    			Award__c newAward = award.clone();
	    			newAward.Activity__c = newActivity.Id;
	    			newAwardList.add(newAward);
	    		}
	    		insert newAwardList;
	    		
	    		List<Requirement__c> newRequirements = new List<Requirement__c>();
	    		for(Requirement__c requirement: Database.Query('Select '+ServiceUtility.getObjectFields(Requirement__c.SobjectType)+' from Requirement__c where Activity__c =: activityId')){
	    			Requirement__c newRequirement = requirement.clone();
	    			newRequirement.Activity__c = newActivity.Id;
	    			newRequirements.add(newRequirement);
	    		}
	    		insert newRequirements;
	    		List<ActivitySkills__c> newActivitySkills = new List<ActivitySkills__c>();
	    		for(ActivitySkills__c activitySkill: Database.query('Select '+ServiceUtility.getObjectFields(ActivitySkills__c.SobjectType)+' from ActivitySkills__c where Activity__c =: activityId')){
	    			ActivitySkills__c newActivitySkill = activitySkill.clone();
	    			newActivitySkill.Activity__c = newActivity.Id;
	    			newActivitySkills.add(newActivitySkill);
	    		}
	    		insert newActivitySkills;
	    	}
    	}
    	catch(Exception ex){
    		Database.rollback(sp);
    		throw ex;
    	}
    	return newActivity;
    }

	public void addAward(Award__c award){
		if(award == null){
    		throw new ServiceException(Label.Required_Award);
    	}
		upsert award;
	}
	
	public void editAward(Award__c award){
		if(award == null || award.Id == null){
    		throw new ServiceException(Label.Required_Award_Award_Id);
    	}
		update award;
	}
	
	public void deleteAward(Award__c award){
		if(award == null || award.Id == null){
    		throw new ServiceException(Label.Required_Award_Award_Id);
    	}
		delete award;
	}
}