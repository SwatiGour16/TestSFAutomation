@isTest
public class TestClassUtility{

     public static Activity__c getActivityInstance(Id storyId){
        Activity__c activity = new Activity__c();
        activity.User_Story__c = storyId;
        activity.Name = 'Test Activity';
        activity.Activity_Type__c = 'Competition';
        activity.Description__c = 'Test Description';
        activity.Cost__c = 10;
        activity.Publisher__c = UserInfo.getUserId();
        return activity;
    }
    
    public static Story__c getStoryInstance(){
        Story__c story = new Story__c();
        story.Name = 'Test Story';
        story.Status__c = 'In Progress';
        story.Description__c = 'Test';
        story.Project_Start_Date__c = System.Today();
        return story;
    }
    
    public static List<Milestone__c> createMilestones(){
        List<Milestone__c> milestones = new List<Milestone__c>();
        Milestone__c milestone1 = new Milestone__c();
        milestone1.Name = 'Published Date';
        milestone1.Due_Date__c = System.now().addDays(-5);
        milestones.add(milestone1);
        Milestone__c milestone2 = new Milestone__c();
        milestone2.Name = 'Review Date';
        milestone2.Due_Date__c = System.now().addDays(-1);
        milestones.add(milestone2);
        insert milestones;
        return milestones;
    }
    
    public static List<Skills__c> createSkills(){
        List<Skills__c> skills = new List<Skills__c>();
        skills.add(new Skills__c(Skill__c = 'c'));
        skills.add(new Skills__c(Skill__c = '.net'));
        insert skills;
        return skills;
    } 
    
    public static List<ActivitySkills__c>  addSkills(Activity__c activity, List<Skills__c> skills){
        List<ActivitySkills__c> activitySkills = new List<ActivitySkills__c>();
        for(Skills__c skill: skills){
            activitySkills.add(new ActivitySkills__c(Activity__c = activity.Id, Skill__c = skill.Id));
        }
        insert activitySkills;
        return activitySkills;
    }   
    
    public static MemberActivityMilestone__c createMemberActivity(Activity__c activity, ActivityMilestones__c activityMilestone){
        MemberActivityMilestone__c memberActivityMilestone = new MemberActivityMilestone__c(Activity__c = activity.Id, ActivityMilestones__c = activityMilestone.Id, Activity_Milestone_Timestamp__c=system.now(), User__c = UserInfo.getUserId());
        insert memberActivityMilestone;
        return memberActivityMilestone;
    }
    
    public static ActivityMilestones__c createActivityMilestone(Activity__c activity, Milestone__c milestone){
        ActivityMilestones__c activityMilestone = new ActivityMilestones__c(Activity__c = activity.Id, Milestone__c = milestone.id);
        insert activityMilestone;
        return activityMilestone;
    }
    
    public static List<Requirement__c> getRequirementsInstance(Activity__c activity){
        List<Requirement__c> requirements = new List<Requirement__c>();
        requirements.add(new Requirement__c(Activity__c = activity.Id, Name = 'Test Requirement 1', Description__c = 'Test'));
        requirements.add(new Requirement__c(Activity__c = activity.Id, Name = 'Test Requirement 2', Description__c = 'Test'));
        return requirements;
    }
    
    public static Award__c getAwardInstance(Activity__c activity){
        return new Award__c(Activity__c = activity.Id, Payment__c = 20);
    }
}